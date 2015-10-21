#
# Cookbook Name:: selinux_policy_test
# Recipe:: fcontext
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Define a single fcontext
ruby_block 'fail-mismatch' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

dir_name = '/var/www/tester'
context = 'http_tmp_t'

selinux_policy_fcontext dir_name do
  secontext context
end

directory dir_name do
  recursive true
end

# Fail if dir isn't actually set
execute 'true' do
  not_if "stat -c %C #{dir_name} | grep #{context}"
  notifies :run, 'ruby_block[fail-mismatch]', :immediate
end

selinux_policy_fcontext 'deleteme' do
  file_spec dir_name
  action :delete
  secontext context
end

execute "restorecon #{dir_name}" # Restore original context

# Shouldn't be in that context anymore
execute 'true' do
  only_if "stat -c %C #{dir_name} | grep #{context}"
  notifies :run, 'ruby_block[fail-mismatch]', :immediate
end
