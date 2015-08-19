include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

# Create if doesn't exist, do not touch if port is already registered (even under different type)
action :add do
  execute "selinux-port-#{new_resource.port}-add" do
    command "/usr/sbin/semanage port -a -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    not_if {port_allowed?(new_resource.secontext, new_resource.protocol, new_resource.port)}
    only_if {use_selinux}
  end
end

# Delete if exists
action :delete do
  execute "selinux-port-#{new_resource.port}-delete" do
    command "/usr/sbin/semanage port -d -p #{new_resource.protocol} #{new_resource.port}"
    only_if {port_allowed?(new_resource.secontext, new_resource.protocol, new_resource.port)}
    only_if {use_selinux}
  end
end

action :modify do
  execute "selinux-port-#{new_resource.port}-modify" do
    command "/usr/sbin/semanage port -m -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    only_if {use_selinux}
  end
end

action :addormodify do
  # add or modify based on whether or not any other context has that port open
  # note this is currently quite inefficient because we're repeating semanage commands 
  execute "selinux-port-#{new_resource.port}-add" do
    command "/usr/sbin/semanage port -a -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    not_if {port_allowed?(nil, new_resource.protocol, new_resource.port)}
    not_if {port_allowed?(new_resource.secontext, new_resource.protocol, new_resource.port)}
    only_if {use_selinux}
  end

  execute "selinux-port-#{new_resource.port}-modify" do
    command "/usr/sbin/semanage port -m -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    only_if {port_allowed?(nil, new_resource.protocol, new_resource.port)}
    not_if {port_allowed?(new_resource.secontext, new_resource.protocol, new_resource.port)}
    only_if {use_selinux}
  end

end

