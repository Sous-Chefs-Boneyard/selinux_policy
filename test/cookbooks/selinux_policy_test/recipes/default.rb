#
# Cookbook Name:: selinux_policy_test
# Recipe:: default
#
# Copyright 2014, Kieren Evans
#
# GPLv2

include_recipe 'selinux::enforcing'
include_recipe 'selinux_policy::install'

selinux_policy_port '1080' do
  protocol 'tcp'
  secontext 'http_port_t'
end
