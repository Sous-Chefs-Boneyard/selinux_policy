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
    package_name='policycoreutils'
  when "rhel" 
    case node['platform_version'].to_i.floor
      when 5
        package_name='policycoreutils'
      when 6
        package_name='policycoreutils-python'
      end
  else raise 'Uknown distro, cannot determine required package name'
end

package package_name do
  action :install
end
