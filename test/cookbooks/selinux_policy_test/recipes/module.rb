#
# Cookbook Name:: selinux_policy_test
# Recipe:: module
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Plays around with an SEModule

# Failure generator
ruby_block 'fail-module' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

selinux_policy_module 'testy' do
  content '
    policy_module(testy, 1.0.0)
    type testy_t;
  '
end

# Expect to find the module
execute 'module-sniff' do
  command 'true'
  not_if "/usr/sbin/semodule -l | grep -w '^testy'"
  notifies :run, 'ruby_block[fail-module]', :immediate
end

selinux_policy_module 'testy-bye' do
  action :remove
  name 'testy'
end

# Expect not to find module
execute 'module-unsniff' do
  command 'true'
  only_if "/usr/sbin/semodule -l | grep -w '^testy'"
  notifies :run, 'ruby_block[fail-module]', :immediate
end
