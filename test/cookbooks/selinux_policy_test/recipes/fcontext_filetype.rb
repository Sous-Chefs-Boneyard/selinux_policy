#
# Cookbook Name:: selinux_policy_test
# Recipe:: fcontext_file_type
#
# Copyright 2016, BackSlasher
#
# GPLv2

# Define a single fcontext
ruby_block 'fail-mismatch-fcontext-filetype' do
  action :nothing
  block do
    raise 'Fail block was invoked'
  end
end

basedir = '/var/www'
symlink = '/var/www/tester_symlink'
context_dir = 'httpd_sys_content_t'
context_dir2 = 'httpd_tmp_t'
context_symlink = 'httpd_sys_rw_content_t'

selinux_policy_fcontext basedir do
  secontext context_dir
  file_type 'd'
end

directory basedir do
  recursive true
end

link symlink do
  to basedir
end

# Should adapt the symlink itself
selinux_policy_fcontext symlink do
  secontext context_symlink
  file_type 'l'
end

# Fail if dir isn't actually set
execute 'true basedir context_dir' do
  not_if "stat -c %C #{basedir} | grep #{context_dir}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end

# Should not run again
selinux_policy_fcontext 'nomod on basedir with context_dir' do
  file_spec basedir
  action :modify
  secontext context_dir
  file_type 'd'
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end

selinux_policy_fcontext 'modme on basedir with context_dir2' do
  file_spec basedir
  action :modify
  secontext context_dir2
  file_type 'd'
end

# Fail if dir hasn't modified context
execute 'true basedir' do
  not_if "stat -c %C #{basedir} | grep #{context_dir2}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end

# Fail if symlink has changed context
execute 'true symlink' do
  not_if "stat -c %C #{symlink} | grep #{context_symlink}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end

# Should not run again
selinux_policy_fcontext 'symlink-nomod' do
  file_spec symlink
  action :modify
  secontext context_symlink
  file_type 'l'
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end

# Should not change the symlink itself, so shouldn't change
selinux_policy_fcontext 'symlink-nomod2' do
  file_spec symlink
  action :modify
  secontext context_dir2
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end

selinux_policy_fcontext 'deleteme basedir' do
  file_spec basedir
  file_type 'd'
  action :delete
end

selinux_policy_fcontext 'deleteme_symlink' do
  file_spec symlink
  file_type 'l'
  action :delete
end

execute "restorecon #{basedir}" # Restore original context

# Shouldn't be in any of our contexts anymore
execute 'true basedir and symlink' do
  not_if "stat -c %C #{basedir} | grep -v #{context_dir}"
  not_if "stat -c %C #{basedir} | grep -v #{context_dir2}"
  not_if "stat -c %C #{symlink} | grep -v #{context_symlink}"
  notifies :run, 'ruby_block[fail-mismatch-fcontext-filetype]', :immediate
end
