# Cookbook: selinux_policy
# Library: helper-disabled
# 2015, GPLv2, Nitzan Raz (http://backslasher.net)

class Chef
  class Provider
    # Checks if SELinux is disabled and whether we're allowed to run when disabled
    def use_selinux
      selinux_disabled= (shell_out!("getenforce").stdout =~ /disabled/i)
      allowed_disabled=node['selinux_policy']['allow_disabled']
      # return false only when SELinux is disabled and it's allowed
      return_val=!(selinux_disabled && allowed_disabled)
      Chef::Log.warn('SELinux is disabled, skipping') if !return_val
      return return_val
    end
  end
end
