#
# Author:: Wade Peacock (wade.peacock@visioncritical.com)
# Cookbook Name:: selinux_policy
# Resource:: port
#
# Original Author:: backslasher
# Original Cookbook Name:: selinux_policy
# Original Resource:: port
#
# Manages a port assignment in SELinux
# See http://docs.fedoraproject.org/en-US/Fedora/13/html/SELinux_FAQ/index.html#id3715134

actions :add, :delete, :reassign, :modify, :addormodify
default_action :add

attribute :port, :kind_of => Integer, :name_attribute => true
attribute :protocol, :kind_of => String, :equal_to => ['tcp', 'udp'], :default => 'tcp'
attribute :secontext, :kind_of => String

attr_accessor :exists, :disabled, :match

