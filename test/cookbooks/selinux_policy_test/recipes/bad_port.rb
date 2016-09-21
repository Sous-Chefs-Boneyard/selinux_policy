#
# Cookbook Name:: selinux_policy_test
# Recipe:: bad_port
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Expect to fail with a bad port string

bad_port = selinux_policy_port 'bad_port' do
  action :nothing
  port '1a2b3c'
  protocol 'tcp'
  secontext 'http_port_t'
end

ruby_block 'bad-port' do
  block do
    caught = false
    begin
      bad_port.provider_for_action(:addormodify).run_action
    rescue ArgumentError
      # We're happy.
      caught = true
    end
    raise 'Invalid port was not complained about' unless caught
  end
end
