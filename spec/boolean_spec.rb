require 'spec_helper'

describe 'selinux_policy boolean' do
  before do
    allow_any_instance_of(Chef::Resource).to receive(:use_selinux).and_return(true)
  end
  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7', step_into: ['selinux_policy_boolean']).converge_dsl('selinux_policy') do
      selinux_policy_boolean 'httpd_can_network_connect_db' do
        value true
      end
      selinux_policy_boolean 'nagios_run_sudo' do
        value false
      end
    end
  end

  describe 'SetAndPersist' do
    it 'when value does not match' do
      stub_command("getsebool httpd_can_network_connect_db | grep 'on$' >/dev/null").and_return(false)
      stub_command("getsebool nagios_run_sudo | grep 'off$' >/dev/null").and_return(false)
      expect(chef_run).to run_execute('selinux-setbool-httpd_can_network_connect_db-on')
      expect(chef_run).to run_execute('selinux-setbool-nagios_run_sudo-off')
    end

    it 'when value does match' do
      stub_command("getsebool httpd_can_network_connect_db | grep 'on$' >/dev/null").and_return(true)
      stub_command("getsebool nagios_run_sudo | grep 'off$' >/dev/null").and_return(true)
      expect(chef_run).not_to run_execute('selinux-setbool-httpd_can_network_connect_db-on')
      expect(chef_run).not_to run_execute('selinux-setbool-nagios_run_sudo-off')
    end
  end
end
