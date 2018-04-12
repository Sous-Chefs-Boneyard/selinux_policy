#
# Cookbook Name:: selinux_policy_test
# Recipe:: single_default_port
#
# Copyright 2015, BackSlasher
#
# GPLv2

# Define a single default port
selinux_policy_port '10080' do
  protocol 'tcp'
  secontext 'http_port_t'
end
