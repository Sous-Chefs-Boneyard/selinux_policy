#
# Author:: Wade Peacock (wade.peacock@visioncritical.com)
# Cookbook Name:: selinux_policy
# Resource:: boolean
#
# Original Author:: backslasher
# Original Cookbook Name:: selinux_policy
# Original Resource:: boolean
#
# A resource for managing SELinux Booleans

actions :set
default_action :set

attribute :name, :kind_of => String, :name_attribute => true
attribute :value, :kind_of => [ TrueClass, FalseClass ]
attribute :persist, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :force, :kind_of => [ TrueClass, FalseClass ], :default => false

attr_accessor :exists, :disabled
