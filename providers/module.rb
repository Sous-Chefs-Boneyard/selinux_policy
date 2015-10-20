include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

def module_defined(name)
  "/usr/sbin/semodule -l | grep -w '^#{name}'"
end

use_inline_resources

# Get all the components in the right place
action :fetch do
  # TODO add more options
  directory new_resource.directory

  if new_resource.content
    file "#{new_resource.directory}/#{new_resource.name}.te" do
      content new_resource.content
      only_if {use_selinux}
    end
  end
end

# compile the module
# XXX allow modifyable path
action :compile do
  make_command = "/usr/bin/make -f /usr/share/selinux/devel/Makefile #{new_resource.name}.pp"
  execute "semodule-compile-#{new_resource.name}" do
    command make_command
    not_if "#{make_command} -q" # $? = 1 means make wants to execute http://www.gnu.org/software/make/manual/html_node/Running.html
    cwd new_resource.directory
  end
end

# deploy / upgrade module
action :install do
  deployed_file = "/etc/selinux/targeted/modules/active/modules/#{new_resource.name}.pp"
  filename = "#{new_resource.directory}/#{new_resource.name}.pp"
  execute "semodule-install-#{new_resource.name}" do
    command  "/usr/sbin/semodule -i #{filename}"
    only_if {use_selinux}
    not_if "#{module_defined(new_resource.name)} && cmp '#{deployed_file}' '#{filename}'" # Do not run if the module is installed and its the same file inside
  end
end

# deploy should do all three, as it used to do
action :deploy do
  run_action(:fetch)
  run_action(:compile)
  run_action(:install)
end

# remove module
action :remove do
  execute "semodule-remove-#{new_resource.name}" do
    command "/usr/sbin/semodule -r #{new_resource.name}"
    only_if module_defined(new_resource.name)
    only_if {use_selinux}
  end
end
