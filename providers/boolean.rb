#
# Author:: Wade Peacock (wade.peacock@visioncritical.com)
# Cookbook Name:: selinux_policy
# Provider:: boolean
#
# Original Author:: backslasher
# Original Cookbook Name:: selinux_policy
# Original Provider:: boolean
#

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :set do
  unless (@current_resource.exists) 
    converge_by("Process set boolean - #{@new_resource}") do
      # Convert true/false to 'on'/'off'
      new_value = @new_resource.value ? 'on' : 'off'
      cmd = "setsebool "
      cmd += "-P " if @new_resource.persist
      cmd += "#{@new_resource.name} #{new_value}"
      shell_out(cmd)
      @new_resource.updated_by_last_action(true)
    end
  end
end

# Support whyrun
def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::SelinuxPolicyBoolean.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  # Get Enforcement level of SELINUX
  cmd = shell_out("getenforce")
  if ( cmd.stdout =~ /disabled/i )
    @current_resource.disabled = true
  else
    @current_resource.disabled = false
  end
  # Unless SELINUX is disabled
  unless @current_resource.disabled
    cmd = shell_out("getsebool #{@new_resource.name}") 
    # Convert true/false to 'on'/'off'
    new_value = @new_resource.value ? 'on' : 'off'
    unless cmd.stdout =~ /#{new_value}$/
      @current_resource.exists = false
    else
      # Set to exists to false if force set to true
      unless @new_resource.force
        @current_resource.exists = true
      else
        @current_resource.exists = false
      end
    end
  else
    # Flag resource as correct if SELINUX is disabled (why would you?)
    @current_resource.exists = true
    Chef::Log.warn("SELINUX is disabled, skipping")
  end
end
