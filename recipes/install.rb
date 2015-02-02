#
# Cookbook Name:: selinux_policy
# Recipe:: install
#
# Copyright 2014, BackSlasher
#
# GPLv2
#

case node['platform_family']
  when "debian"
    pkgs = [ 'policycoreutils', 'selinux-policy-dev', 'make' ]
  when "rhel"
    # Handle RHEL 5 vs 6
    case node['platform_version'].to_i.floor
      when 5
        # This pulls in all dependencies
        pkgs = [ 'policycoreutils', 'selinux-policy', 'make' ]
      when 6
        # This pulls in all dependencies
        pkgs = [ 'policycoreutils-python', 'selinux-policy', 'make' ]
      end
  else raise 'Uknown distro, cannot determine required package name'
end

pkgs.each do | pkg | 
  package pkg do
    action :install
  end
end
