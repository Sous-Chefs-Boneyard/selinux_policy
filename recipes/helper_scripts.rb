#
# Cookbook Name:: selinux_policy
# Recipe:: helper_scripts
#
# Copyright 2014, BackSlasher
#
# GPLv2
#
# Copies our helper scripts
remote_directory node['selinux_policy']['script_location'] do
  recursive true

  files_mode '555'
end


