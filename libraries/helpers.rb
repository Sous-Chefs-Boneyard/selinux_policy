

class Chef
  module SELinuxPolicy
    module Helpers
      require 'chef/mixin/shell_out'
      include Chef::Mixin::ShellOut
      # Checks if SELinux is disabled or otherwise unavailable and
      # whether we're allowed to run when disabled
      def use_selinux
        begin
          getenforce = shell_out!('getenforce')
        rescue
          selinux_disabled = true
        else
          selinux_disabled = getenforce.stdout =~ /disabled/i
        end
        allowed_disabled = node['selinux_policy']['allow_disabled']
        # return false only when SELinux is disabled and it's allowed
        return_val = !(selinux_disabled && allowed_disabled)
        Chef::Log.warn('SELinux is disabled / unreachable, skipping') unless return_val
        return_val
      end
    end
  end
end
