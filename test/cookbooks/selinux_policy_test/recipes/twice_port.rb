#
# Cookbook Name:: selinux_policy_test
# Recipe:: twice_port
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Define the same port twice and make sure nothing is done the second time

# Failure generator
ruby_block 'fail-twice' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

# Define a single port
selinux_policy_port '1081' do
  protocol 'tcp'
  secontext 'http_port_t'
end

# Again
selinux_policy_port '1081-again' do
  port 1081
  protocol 'tcp'
  secontext 'http_port_t'
  notifies :run, 'ruby_block[fail-twice]', :immediate
end
