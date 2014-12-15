#
# Cookbook Name:: selinux_policy
# Recipe:: install
#
# Copyright 2014, BackSlasher
#
# GPLv2
#
case platform_family
when "debian" pkgs = [ 'policycoreutils', 'selinux-policy-dev', 'make' ]
when "rhel" pkgs = [ 'policycoreutils', 'selinux-policy', 'make' ]
else raise 'Uknown distro, cannot determine required package names'
end

pkgs.each{|p|package p}
