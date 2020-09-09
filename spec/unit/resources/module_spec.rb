require 'spec_helper'

describe 'selinux_policy_module' do
  platform 'centos', '8'
  step_into :selinux_policy_module
  include_context 'selinux enabled'

  before do
    allow(Chef::Config).to receive(:[]).and_call_original
    allow(Chef::Config).to receive(:[]).with(:file_cache_path).and_return('/cachedir')
  end

  recipe do
    selinux_policy_module 'test' do
      content 'foo'
    end

    selinux_policy_module 'directory' do
      directory_source 'foo/bar'
      cookbook 'baz'
    end
  end

  context 'when module is not installed' do
    before do
      stub_command('/usr/bin/make -f /usr/share/selinux/devel/Makefile test.pp -q').and_return(false)
      stub_command("false || ! (/sbin/semodule -l | grep -w '^test') ").and_return(true)
      stub_command('/usr/bin/make -f /usr/share/selinux/devel/Makefile directory.pp -q').and_return(false)
      stub_command("false || ! (/sbin/semodule -l | grep -w '^directory') ").and_return(true)
    end

    it { is_expected.to create_directory('/cachedir/test') }
    it do
      is_expected.to create_file('/cachedir/test/test.te').with(
        content: 'foo'
      )
    end
    it do
      is_expected.to run_execute('semodule-compile-test').with(
        command: '/usr/bin/make -f /usr/share/selinux/devel/Makefile test.pp'
      )
    end
    it do
      is_expected.to run_execute('semodule-install-test').with(
        command: '/sbin/semodule -i /cachedir/test/test.pp'
      )
    end

    it { is_expected.to create_directory('/cachedir/directory') }
    it do
      is_expected.to create_remote_directory('/cachedir/directory').with(
        source: 'foo/bar',
        cookbook: 'baz'
      )
    end
    it do
      is_expected.to run_execute('semodule-compile-directory').with(
        command: '/usr/bin/make -f /usr/share/selinux/devel/Makefile directory.pp'
      )
    end
    it do
      is_expected.to run_execute('semodule-install-directory').with(
        command: '/sbin/semodule -i /cachedir/directory/directory.pp'
      )
    end
  end

  context 'when module is installed' do
    before do
      stub_command('/usr/bin/make -f /usr/share/selinux/devel/Makefile test.pp -q').and_return(true)
      stub_command("false || ! (/sbin/semodule -l | grep -w '^test') ").and_return(false)
      stub_command('/usr/bin/make -f /usr/share/selinux/devel/Makefile directory.pp -q').and_return(true)
      stub_command("false || ! (/sbin/semodule -l | grep -w '^directory') ").and_return(false)
    end

    it { is_expected.to_not run_execute('semodule-compile-test') }
    it { is_expected.to_not run_execute('semodule-install-test') }

    it { is_expected.to_not run_execute('semodule-compile-directory') }
    it { is_expected.to_not run_execute('semodule-install-directory') }
  end

  context 'when both content and source_dir are specified' do
    recipe do
      selinux_policy_module 'both' do
        content 'foo'
        directory_source 'bar'
      end
    end

    it do
      expect { chef_run }.to raise_error(RuntimeError)
    end
  end
end
