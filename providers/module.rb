include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

def module_defined(name)
  "/usr/sbin/semodule -l | grep -w '^#{name}'"
end

use_inline_resources

# Compile and deploy module (also upgrade)
action :deploy do
  filename="semodule-#{new_resource.name}"
  f = file "#{Chef::Config[:file_cache_path]}/#{filename}.te" do
    content new_resource.content
    # notifies :run, "execute[semodule-deploy-#{new_resource.name}]"
    only_if {use_selinux}
  end

  e=execute "semodule-deploy-#{new_resource.name}" do
    # action ( new_resource.force ? :run : :nothing )
    command "/usr/bin/make -f /usr/share/selinux/devel/Makefile #{filename}.pp && /usr/sbin/semodule -i #{filename}.pp"
    only_if {f.updated_by_last_action? or new_resource.force or (shell_out(module_defined(name)).stdout == '')}
    cwd Chef::Config[:file_cache_path]
    only_if {use_selinux}
  end
end

# remove module
action :remove do
  execute "semodule-remove-#{new_resource.name}" do
    command "/usr/sbin/semodule -r #{new_resource.name}"
    only_if module_defined(new_resource.name)
    only_if {use_selinux}
  end
end
