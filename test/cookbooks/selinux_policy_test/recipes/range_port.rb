#
# Cookbook Name:: selinux_policy_test
# Recipe:: range_port
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Ensures a port is correctly detected when a range is already defined

# Failure generator
ruby_block 'fail-range' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

# Manually define ports
execute '/usr/sbin/semanage port -a -t http_port_t  -p tcp 1900-1902' do
  not_if '/usr/sbin/semanage port -l | grep http_port_t | grep 1900-1902'
end
selinux_policy_port 1901 do #### modify to 5001
  protocol 'tcp'
  secontext 'http_port_t'
  notifies :run, 'ruby_block[fail-range]', :immediate
end
