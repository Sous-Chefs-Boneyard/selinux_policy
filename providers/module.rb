include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

# Compile and deploy module (also upgrade)
action :deploy do
  directory "#{Chef::Config[:file_cache_path]}/semodule-#{new_resource.name}" do
    action :create
  end

  # If new_resource.content.nil? then assume the file was created in the calling recipe using file_cookbook or template
  file "#{Chef::Config[:file_cache_path]}/semodule-#{new_resource.name}/#{new_resource.name}.te" do
    content new_resource.content
    # notifies :run, "execute[semodule-deploy-#{new_resource.name}]"
    only_if {use_selinux}
    not_if {new_resource.content.nil?}
  end

  execute "semodule-deploy-#{new_resource.name}" do
    command "/usr/bin/make -f /usr/share/selinux/devel/Makefile load"
    cwd "#{Chef::Config[:file_cache_path]}/semodule-#{new_resource.name}"
    only_if {use_selinux}
  end
end

# remove module
action :remove do
  execute "semodule-remove-#{new_resource.name}" do
    command "/usr/sbin/semodule -r #{new_resource.name}"
    only_if "/usr/sbin/semodule -l | grep -w '#{new_resource.name}'"
    only_if {use_selinux}
  end
end
