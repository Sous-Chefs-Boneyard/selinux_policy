# a resource for managing selinux permissive contexts

property :allow_disabled, [true, false], default: true

unified_mode true

# Create if doesn't exist, do not touch if port is already registered (even under different type)
action :add do
  execute "selinux-permissive-#{new_resource.name}-add" do
    command "#{semanage_cmd} permissive -a '#{new_resource.name}'"
    not_if  "#{semanage_cmd} permissive -l | grep  '^#{new_resource.name}$'"
    only_if { use_selinux(new_resource.allow_disabled) }
  end
end

# Delete if exists
action :delete do
  execute "selinux-port-#{new_resource.name}-delete" do
    command "#{semanage_cmd} permissive -d '#{new_resource.name}'"
    not_if  "#{semanage_cmd} permissive -l | grep  '^#{new_resource.name}$'"
    only_if { use_selinux(new_resource.allow_disabled) }
  end
end

action_class do
  include Chef::SELinuxPolicy::Helpers
end
