require 'spec_helper'

describe 'selinux_policy_port' do
  platform 'centos', '8'
  step_into :selinux_policy_port
  include_context 'selinux enabled'

  recipe do
    selinux_policy_port '12345' do
      protocol 'tcp'
      secontext 'aom_context'
    end

    selinux_policy_port '12346' do
      protocol 'tcp'
      secontext 'add_context'
      action :add
    end

    selinux_policy_port '12347' do
      protocol 'tcp'
      secontext 'modify_context'
      action :modify
    end

    selinux_policy_port '12348' do
      protocol 'tcp'
      action :delete
    end
  end

  before do
    [
      %w(aom 12345),
      %w(add 12346),
      %w(modify 12347),
      %w(delete 12348),
    ].each do |c, p|
      stub_command("seinfo --portcon=#{p} | grep 'portcon tcp' | awk -F: '$(NF-1) !~ /reserved_port_t$/ && $(NF-3) !~ /[0-9]*-[0-9]*/ {print $(NF-1)}' | grep -q ^").and_return(has_context)
      stub_command("seinfo --portcon=#{p} | grep 'portcon tcp' | awk -F: '$(NF-1) !~ /reserved_port_t$/ && $(NF-3) !~ /[0-9]*-[0-9]*/ {print $(NF-1)}' | grep -P '#{c}_context'").and_return(has_correct_context)
    end
  end

  context 'when port is not defined' do
    let(:has_context) { false }
    let(:has_correct_context) { false }

    it do
      is_expected.to run_execute('selinux-port-12345-add').with(
        command: '/sbin/semanage port -a -t aom_context -p tcp 12345'
      )
    end
    it { is_expected.to_not run_execute('selinux-port-12345-modify') }

    it do
      is_expected.to run_execute('selinux-port-12346-add').with(
        command: '/sbin/semanage port -a -t add_context -p tcp 12346'
      )
    end

    it { is_expected.to_not run_execute('selinux-port-12347-modify') }

    it { is_expected.to_not run_execute('selinux-port-12348-delete') }
  end

  context 'when port has other value' do
    let(:has_context) { true }
    let(:has_correct_context) { false }

    it { is_expected.to_not run_execute('selinux-port-12345-add') }
    it do
      is_expected.to run_execute('selinux-port-12345-modify').with(
        command: '/sbin/semanage port -m -t aom_context -p tcp 12345'
      )
    end

    it { is_expected.to_not run_execute('selinux-port-12346-add') }

    it do
      is_expected.to run_execute('selinux-port-12347-modify').with(
        command: '/sbin/semanage port -m -t modify_context -p tcp 12347'
      )
    end

    it do
      is_expected.to run_execute('selinux-port-12348-delete').with(
        command: '/sbin/semanage port -d -p tcp 12348'
      )
    end
  end

  context 'when port has correct value' do
    let(:has_context) { true }
    let(:has_correct_context) { true }

    it { is_expected.to_not run_execute('selinux-port-12345-add') }
    it { is_expected.to_not run_execute('selinux-port-12345-modify') }

    it { is_expected.to_not run_execute('selinux-port-12346-add') }

    it { is_expected.to_not run_execute('selinux-port-12347-modify') }

    it do
      is_expected.to run_execute('selinux-port-12348-delete').with(
        command: '/sbin/semanage port -d -p tcp 12348'
      )
    end
  end

  context 'when given a bad port' do
    let(:has_context) { false }
    let(:has_correct_context) { false }

    recipe do
      selinux_policy_port 'bad port' do
        port 'something invalid'
        protocol 'tcp'
        secontext 'foo'
      end
    end

    it do
      expect { chef_run }.to raise_error(ArgumentError)
    end
  end
end
