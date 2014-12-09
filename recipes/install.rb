#
# Cookbook Name:: selinux_policy
# Recipe:: install
#
# Copyright 2014, BackSlasher
#
# GPLv2
#
case platform_family
when "debian" package_name='policycoreutils'
when "rhel" package_name='policycoreutils'
else raise 'Uknown distro, cannot determine required package name'
end

package package_name
