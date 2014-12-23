#
# Author:: Wade Peacock (wade.peacock@visioncritical.com)
# Cookbook Name:: selinux_policy
# Provider:: port
#
# Original Author:: backslasher
# Original Cookbook Name:: selinux_policy
# Original Provider:: port
#

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :delete do
  if @current_resource.exists && @current_resource.match
    converge_by("Process deletion of port - #{@new_resource}") do
      cmd = shell_out("semanage port -d -t #{@new_resource.secontext} -p #{@new_resource.protocol} #{@new_resource.port}")
      # Need to add error support for attempts to remove ports defined by a policy
      @new_resource.updated_by_last_action(true)
    end
  end
end

action :add do
  unless (@current_resource.exists && @current_resource.match) 
    converge_by("Process addition of port - #{@new_resource}") do
      cmd = shell_out("semanage port -a -t #{@new_resource.secontext} -p #{@new_resource.protocol} #{@new_resource.port}")
      @new_resource.updated_by_last_action(true)
    end
  else
    unless (@current_resource.exists && @current_resource.match)  
      Chef::Log.info("Port is already assigned not another secontext - use :switch action")
    end
  end
end

action :modify do
  unless ( @current_resource.exists && @current_resource.match )
    converge_by("Process reassignment of port - #{@new_resource}") do
      cmd = shell_out("semanage port -m -t #{@new_resource.secontext} -p #{@new_resource.protocol} #{@new_resource.port}")
      @new_resource.updated_by_last_action(true)
    end
  end
end

action :addormodify do
  unless (@current_resource.exists && !@current_resource.match) 
    converge_by("Process addition of port - #{@new_resource}") do
      cmd = shell_out("semanage port -a -t #{@new_resource.secontext} -p #{@new_resource.protocol} #{@new_resource.port}")
      @new_resource.updated_by_last_action(true)
    end
  else
    converge_by("Process reassignment of port - #{@new_resource}") do
      cmd = shell_out("semanage port -m -t #{@new_resource.secontext} -p #{@new_resource.protocol} #{@new_resource.port}")
      @new_resource.updated_by_last_action(true)
    end
  end
end

# Support whyrun
def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::SelinuxPolicyPort.new(@new_resource.name)
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
    cmd = shell_out("semanage port -l | grep #{@new_resource.protocol}") 
    # Remove commas
    cmd_array = cmd.stdout.gsub(/,/,'')
    # Split on spaces into an array
    cmd_array = cmd_array.split(" ")
    unless cmd_array.include? @new_resource.port
      @current_resource.exists = false
    else
      @current_resource.exists = true
    end
    if @current_resource.exists
      cmd = shell_out("semanage port -l |  grep #{@new_resource.secontext} | grep #{@new_resource.protocol}")
      # Unless SELINUX is disabled
      if ( cmd.stdout.empty? )
        @current_resource.match = false
      else
        # Remove commas
        cmd_array = cmd.stdout.gsub(/,/,'')
        # Split on spaces into an array
        cmd_array = cmd_array.split(" ")
        unless cmd_array.include? @new_resource.port
          @current_resource.match = false
        else
          @current_resource.match = true
        end
      end
    else
        @current_resource.match = false
    end
  else
    # Flag resource as correct if SELINUX is disabled (why would you?)
    @current_resource.exists = true
    @current_resource.match = true
    Chef::Log.warn("SELINUX is disabled, skipping")
  end
end
