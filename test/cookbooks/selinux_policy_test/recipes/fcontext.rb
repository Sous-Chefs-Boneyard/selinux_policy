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

selinux_policy_fcontext '/tmp/test' do
  secontext 'httpd_tmp_t'
end

directory '/tmp/test'

# Fail if dir isn't actually set
execute 'true' do
  not_if 'stat -c %C /tmp/test | grep httpd_tmp_t'
  notifies :run, 'ruby_block[fail-mismatch]', :immediate
end

selinux_policy_fcontext '/tmp/test-again' do
  file_spec '/tmp/test'
  action :delete
end

execute 'restorecon /tmp/test' # Restore original context

# Shouldn't be in that context anymore
execute 'true' do
  only_if 'stat -c %C /tmp/test | grep httpd_tmp_t'
  notifies :run, 'ruby_block[fail-mismatch]', :immediate
end
