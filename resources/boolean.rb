# A resource for managing SELinux Booleans

property :value, [true, false]
property :force, [true, false], default: false
property :allow_disabled, [true, false], default: true

action_class do
  def sebool(persist = false)
    persist_string = persist ? '-P' : ''
    new_value = new_resource.value ? 'on' : 'off'

    execute "selinux-setbool-#{new_resource.name}-#{new_value}" do
      command "#{setsebool_cmd} #{persist_string} #{new_resource.name} #{new_value}"
      not_if "#{getsebool_cmd} #{new_resource.name} | grep -q '#{new_value}$'" unless new_resource.force
      only_if { use_selinux(new_resource.allow_disabled) }
    end
  end
end

# Set and persist
action :setpersist do
  sebool(true)
end

# Set for now, without persisting
action :set do
  sebool(false)
end
