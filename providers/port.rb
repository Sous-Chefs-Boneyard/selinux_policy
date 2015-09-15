include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

def prepare_scripts
  run_context.include_recipe 'selinux_policy::helper_scripts'
end

def port_defined(port,protocol,label=nil)
  "#{node['selinux_policy']['script_location']}/port_locate.py #{protocol} #{port} #{label}"
end

# Create if doesn't exist, do not touch if port is already registered (even under different type)
action :add do
  prepare_scripts

  execute "selinux-port-#{new_resource.port}-add" do
    command "/usr/sbin/semanage port -a -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    not_if port_defined(new_resource.port, new_resource.protocol)
    only_if {use_selinux}
  end
end

# Delete if exists
action :delete do
  prepare_scripts

  execute "selinux-port-#{new_resource.port}-delete" do
    command "/usr/sbin/semanage port -d -p #{new_resource.protocol} #{new_resource.port}"
    only_if port_defined(new_resource.port, new_resource.protocol)
    only_if {use_selinux}
  end
end

action :modify do
  prepare_scripts

  execute "selinux-port-#{new_resource.port}-modify" do
    command "/usr/sbin/semanage port -m -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    only_if {use_selinux}
  end
end

action :addormodify do
  prepare_scripts

  execute "selinux-port-#{new_resource.port}-addormodify" do
    command <<-EOT
    if #{port_defined(new_resource.port, new_resource.protocol)}; then
      /usr/sbin/semanage port -m -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}
    else
      /usr/sbin/semanage port -a -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}
    fi
    EOT
    not_if port_defined(new_resource.port, new_resource.protocol, new_resource.secontext)
    only_if {use_selinux}
  end
end
