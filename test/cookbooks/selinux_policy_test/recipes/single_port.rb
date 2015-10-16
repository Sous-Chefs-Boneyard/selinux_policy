#
# Cookbook Name:: selinux_policy_test
# Recipe:: single_port
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Define a single port
selinux_policy_port '1080' do
  protocol 'tcp'
  secontext 'http_port_t'
end
