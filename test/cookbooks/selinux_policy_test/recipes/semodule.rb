#
# Cookbook Name:: selinux_policy_test
# Recipe:: semodule
#
# Copyright 2015, Antek S. Baranski
#
# GPLv2

include_recipe 'selinux::enforcing'
include_recipe 'selinux_policy::install'

modulename = 'p4d'
path = "#{Chef::Config[:file_cache_path]}/semodule-#{modulename}"

directory path do
  action :create
end

cookbook_file "#{path}/#{modulename}.te" do
  source "#{modulename}.te"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

cookbook_file "#{path}/#{modulename}.if" do
  source "#{modulename}.if"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

cookbook_file "#{path}/#{modulename}.fc" do
  source "#{modulename}.fc"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

Log.warn ('Installing p4d module - #1')

selinux_policy_module "#{modulename} 1" do
  name modulename
  action :deploy
end

Log.warn ('Deleting pp module file - #1')

file "#{path}/#{modulename}.pp" do
  action :delete
end

Log.warn ('Installing p4d module - #2')

selinux_policy_module "#{modulename} 2" do
  name modulename
  action :deploy
  force true
end

Log.warn ('Deleting pp module file - #2')

file "#{path}/#{modulename}.pp" do
  action :delete
end

Log.warn ('Installing p4d module - #3')

selinux_policy_module "#{modulename} 3" do
  name modulename
  action :deploy
end
