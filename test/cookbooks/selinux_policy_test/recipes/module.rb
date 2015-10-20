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

module_content = <<-eos
    policy_module(testy, 1.0.0)
    type testy_t;
  eos

m = selinux_policy_module 'testy' do
  content module_content
end

# Expect to find the module
execute 'module-sniff' do
  command 'true'
  not_if "/usr/sbin/semodule -l | grep -w '^testy'"
  notifies :run, 'ruby_block[fail-module]', :immediate
end

# Should not be reinstalled
selinux_policy_module 'testy-again' do
  module_name 'testy'
  content module_content
  notifies :run, 'ruby_block[fail-module]', :immediate
end

selinux_policy_module 'testy-bye' do
  action :remove
  module_name 'testy'
  directory m.directory # Hack but should simulate the real world better
end

# Expect not to find module
execute 'module-unsniff' do
  command 'true'
  only_if "/usr/sbin/semodule -l | grep -w '^testy'"
  notifies :run, 'ruby_block[fail-module]', :immediate
end
