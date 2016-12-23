require 'spec_helper'

describe 'selinux_policy port' do
  describe 'single port' do
    describe 'AddOrModify' do
      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_port'])
        Chef::Config[:cookbook_path] << './test/cookbooks'
        runner.converge('selinux_policy_test::single_port') do
          runner.node.override['selinux_policy']['allow_disabled'] = false
        end
      end
      it 'defines a single port' do
        stub_command("seinfo --protocol=tcp --portcon=1080 | awk -F: '$(NF-1) !~ /reserved_port_t$/ {print $(NF-1)}' | grep -q ^").and_return(false)
        expect(chef_run).to     run_execute('selinux-port-1080-add')
        expect(chef_run).not_to run_execute('selinux-port-1080-modify')
      end
      it 'redefines the port' do
        stub_command("seinfo --protocol=tcp --portcon=1080 | awk -F: '$(NF-1) !~ /reserved_port_t$/ {print $(NF-1)}' | grep -q ^").and_return(true)
        stub_command("seinfo --protocol=tcp --portcon=1080 | awk -F: '$(NF-1) !~ /reserved_port_t$/ {print $(NF-1)}' | grep -P 'http_port_t'").and_return(false)
        expect(chef_run).not_to run_execute('selinux-port-1080-add')
        expect(chef_run).to     run_execute('selinux-port-1080-modify')
      end
      it 'avoids redefining the port' do
        stub_command("seinfo --protocol=tcp --portcon=1080 | awk -F: '$(NF-1) !~ /reserved_port_t$/ {print $(NF-1)}' | grep -q ^").and_return(true)
        stub_command("seinfo --protocol=tcp --portcon=1080 | awk -F: '$(NF-1) !~ /reserved_port_t$/ {print $(NF-1)}' | grep -P 'http_port_t'").and_return(true)
        expect(chef_run).not_to run_execute('selinux-port-1080-add')
        expect(chef_run).not_to run_execute('selinux-port-1080-modify')
      end
    end
    # TODO: 'Add':
    # when port is OK
    # when port is different label
    # when port doesn't exist
    # TODO 'Modify':
    # when port is OK
    # when said port exists
    # when port doesn't exist
    # TODO 'Delete'
    # when port is not there (OK)
    # when port exists
  end

  describe 'range of ports' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_port'])
      Chef::Config[:cookbook_path] << './test/cookbooks'
      runner.converge('selinux_policy_test::range_port') do
        runner.node.override['selinux_policy']['allow_disabled'] = false
      end
    end
    # TODO: complete
    # it 'defines a port' do
    #  expect(chef_run).to run_execute('selinux-port-1901-addormodify')
    # end
    # it 'correctly detects a port in range' do
    #  expect(chef_run).to run_execute('selinux-port-1901-addormodify')
    # end
    # TODO testing:
    # The matching script is not actually being tested here, so we can only check how the script responds on "match" and "no match"
  end
end
