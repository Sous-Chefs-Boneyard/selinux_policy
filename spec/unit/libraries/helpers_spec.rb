require 'spec_helper'

describe SELinuxPolicy::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include SELinuxPolicy::Cookbook::Helpers
  end

  subject { DummyClass.new }

  # manually mock fauxhai data since that cannot be used without a recipe
  before do
    allow(subject).to receive(:[]).with(:platform_family).and_return('rhel')
    allow(subject).to receive(:[]).with('platform_version').and_return('8')
  end

  describe '#use_selinux' do
    let(:shellout) do
      double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0, live_stream: '')
    end

    before { allow(Mixlib::ShellOut).to receive(:new).and_return(shellout) }

    context 'when selinux is permissive' do
      before { allow(shellout).to receive('stdout').and_return('Permissive') }

      it 'returns the correct value' do
        expect(subject.use_selinux(true)).to eq true
      end
      it 'returns the correct value when not allowing disabled' do
        expect(subject.use_selinux(false)).to eq true
      end
    end

    context 'when selinux is enforcing' do
      before { allow(shellout).to receive('stdout').and_return('Enforcing') }

      it 'returns the correct value' do
        expect(subject.use_selinux(true)).to eq true
      end
      it 'returns the correct value when not allowing disabled' do
        expect(subject.use_selinux(false)).to eq true
      end
    end

    context 'when selinux is disabled' do
      before { allow(shellout).to receive('stdout').and_return('Disabled') }

      it 'returns the correct value' do
        expect(subject.use_selinux(true)).to eq false
      end
      it 'returns the correct value when not allowing disabled' do
        expect(subject.use_selinux(false)).to eq true
      end
    end

    context 'selinux is not installed' do
      before { allow(Mixlib::ShellOut).to receive(:new).and_raise(Errno::ENOENT) }

      it 'returns the correct value' do
        expect(subject.use_selinux(true)).to eq false
      end
      it 'returns the correct value when not allowing disabled' do
        expect(subject.use_selinux(false)).to eq true
      end
    end
  end

  describe '#module_defined' do
    before { allow(subject).to receive(:semodule_cmd).and_return('semodule') }

    context 'with testname' do
      it 'returns the correct command string' do
        expect(subject.module_defined('testname')).to eq "semodule -l | grep -w '^testname'"
      end
    end
  end

  describe '#shell_boolean' do
    context 'with truthy expression' do
      it 'returns the correct bool string' do
        expect(subject.shell_boolean(true)).to eq 'true'
      end
    end

    context 'with falsy expression' do
      it 'returns the correct bool string' do
        expect(subject.shell_boolean(false)).to eq 'false'
      end
    end
  end

  describe '#port_defined' do
    awk_cmd = "awk -F: '$(NF-1) !~ /reserved_port_t$/ && $(NF-3) !~ /[0-9]*-[0-9]*/ {print $(NF-1)}'"

    context 'without label' do
      it 'returns the correct command string' do
        expect(subject.port_defined('tcp', '6969')).to eq "seinfo --portcon=6969 | grep 'portcon tcp' | #{awk_cmd} | grep -q ^"
      end
    end

    context 'with label string' do
      it 'returns the correct command string' do
        expect(subject.port_defined('udp', '6970', 'testlabel')).to eq "seinfo --portcon=6970 | grep 'portcon udp' | #{awk_cmd} | grep -P 'testlabel'"
      end
    end

    context 'with label regex' do
      it 'returns the correct command string' do
        expect(subject.port_defined('tcp', '6971', 'escape.+test')).to eq "seinfo --portcon=6971 | grep 'portcon tcp' | #{awk_cmd} | grep -P 'escape\\.\\+test'"
      end
    end
  end

  describe '#fcontext_defined' do
    before { allow(subject).to receive(:semanage_cmd).and_return('semanage') }

    context 'without label' do
      it 'returns the correct command string' do
        expect(subject.fcontext_defined('test/file.path', 'f')).to eq "semanage fcontext -l | grep -qP '^test/file\\.path\\s+regular\\ file\\s+'"
      end
    end

    context 'with label' do
      it 'returns the correct command string' do
        expect(subject.fcontext_defined('test/file.path', 'a', 'test_label_t')).to eq "semanage fcontext -l | grep -qP '^test/file\\.path\\s+all\\ files\\s+system_u:object_r:test_label_t:s0\\s*$'"
      end
    end
  end

  describe '#semanage_options' do
    %w(a f d c b s l p).each do |type|
      context "with file type #{type}" do
        it 'returns the correct string' do
          expect(subject.semanage_options(type)).to eq "-f #{type}"
        end
      end
    end

    context 'on centos 6' do
      before { allow(subject).to receive(:[]).with('platform_version').and_return('6') }

      context 'with file type a' do
        it 'returns the correct string' do
          expect(subject.semanage_options('a')).to eq '-f ""'
        end
      end
      context 'with file type f' do
        it 'returns the correct string' do
          expect(subject.semanage_options('f')).to eq '-f --'
        end
      end
      %w(d c b s l p).each do |type|
        context "with file type #{type}" do
          it 'returns the correct string' do
            expect(subject.semanage_options(type)).to eq "-f -#{type}"
          end
        end
      end
    end
  end

  %w(
    setsebool_cmd
    getsebool_cmd
    getenforce_cmd
    semanage_cmd
    semodule_cmd
  ).each do |command|
    describe "##{command}" do
      it 'returns the correct path' do
        expect(subject.send(command)).to eq "/sbin/#{command.gsub(/_cmd/, '')}"
      end

      context 'on centos 6' do
        before { allow(subject).to receive(:[]).with('platform_version').and_return('6') }

        it 'returns the correct path' do
          expect(subject.send(command)).to eq "/usr/sbin/#{command.gsub(/_cmd/, '')}"
        end
      end
    end
  end
end
