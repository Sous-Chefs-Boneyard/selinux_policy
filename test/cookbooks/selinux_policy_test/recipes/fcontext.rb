#
# Cookbook Name:: selinux_policy_test
# Recipe:: fcontext
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Define a single fcontext
ruby_block 'fail-mismatch-fcontext' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

dir_name = '/var/www/tester'
subdir = '/var/www/tester/testregex'
regex = '/var/www/tester(/.*)?'
context = 'httpd_tmp_t'
context2 = 'boot_t'

selinux_policy_fcontext dir_name do
  secontext context
end

directory dir_name do
  recursive true
end

# Fail if dir isn't actually set
execute 'true dir context' do
  not_if "stat -c %C #{dir_name} | grep #{context}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext]', :immediate
end

# Should not run again
selinux_policy_fcontext 'nomod on dir_name' do
  file_spec dir_name
  action :modify
  secontext context
  notifies :run, 'ruby_block[fail-mismatch-fcontext]', :immediate
end

selinux_policy_fcontext 'modme' do
  file_spec dir_name
  action :modify
  secontext context2
end

# Fail if dir hasn't modified context
execute 'true dir context2' do
  not_if "stat -c %C #{dir_name} | grep #{context2}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext]', :immediate
end

selinux_policy_fcontext 'deleteme dir_name' do
  file_spec dir_name
  action :delete
end

# Testing regexes
directory subdir do
  recursive true
end

selinux_policy_fcontext regex do
  secontext context
end

# Fail if subdir hasn't modified context
execute 'true subdir context' do
  not_if "stat -c %C #{subdir} | grep #{context}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext]', :immediate
end

selinux_policy_fcontext 'deleteregex' do
  file_spec regex
  action :delete
end

execute "restorecon -iR #{dir_name}" # Restore original context

# Shouldn't be in any of our contexts anymore
execute 'true dir context and context2' do
  not_if "stat -c %C #{dir_name} | grep -v #{context}"
  not_if "stat -c %C #{dir_name} | grep -v #{context2}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext]', :immediate
end
