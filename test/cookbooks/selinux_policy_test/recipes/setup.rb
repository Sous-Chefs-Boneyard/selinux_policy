#
# Cookbook Name:: selinux_policy_test
# Recipe:: setup
#
# Copyright 2015, Nitzan
#
# GPLv2
#
# Sets the machine up for selinux goodness

include_recipe 'selinux_policy::install'

bash 'SELinux Enforcing' do
  code 'setenforce 1'
  user 'root'
  not_if { `getenforce`.strip == 'Enforcing' }
end
