#
# Cookbook Name:: selinux_policy_test
# Recipe:: bad_port
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Failure generator
ruby_block 'bad-port' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

# Expect to fail with a bad port string
bad_port = selinux_policy_port 'bad_port' do
  port '1a2b3c'
  protocol 'tcp'
  secontext 'http_port_t'
  ignore_failure true
  notifies :run, 'ruby_block[bad-port]', :immediate
end
