# A resource for managing SELinux Booleans

property :value, [true, false]
property :force, [true, false], default: false
property :allow_disabled, [true, false], default: true

unified_mode true

# Set and persist
action :setpersist do
  sebool(new_resource, true)
end

# Set for now, without persisting
action :set do
  sebool(new_resource, false)
end

action_class do
  include Chef::SELinuxPolicy::Helpers
end
