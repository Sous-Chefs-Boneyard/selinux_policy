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
    raise 'Install SELinux manually on Ubuntu. See https://wiki.ubuntu.com/SELinux' if node["platform"] == 'ubuntu'
    pkgs = [ 'policycoreutils', 'selinux-policy-dev', 'make' ]
  when "rhel"
    case node['platform_version'].to_i
      when 5
        # policycoreutils-python does not exist in RHEL5
        pkgs = [ 'policycoreutils', 'selinux-policy-devel', 'make' ]
      when 6
        # selinux-policy-devel does not exist in RHEL6
        pkgs = [ 'policycoreutils-python', 'selinux-policy', 'make' ]
      when 7
        pkgs = [ 'policycoreutils-python', 'selinux-policy-devel', 'make' ]
      else
        raise 'Unknown version of RHEL/derivative, cannot determine required package names'
    end
  else
    raise 'Unknown distro, cannot determine required package names'
end

pkgs.each{|p|package p}
