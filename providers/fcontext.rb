include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

def fcontext_defined(file_spec,label=nil)
  base_command = "semanage fcontext -l | grep -P '^#{Regexp.escape(file_spec)}\\s'"
  "#{base_command} | grep -P '\\ssystem_u:object_r:#{Regexp.escape(label)}:s0$'" if label
end

use_inline_resources

# Create if doesn't exist, do not touch if fcontext is already registered
action :add do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  execute "selinux-fcontext-#{new_resource.secontext}-add" do
    command "/usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}' && #{restorecon(new_resource.file_spec)}"
    not_if fcontext_defined(new_resource.file_spec)
    only_if {use_selinux}
  end
end

# Delete if exists
action :delete do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  execute "selinux-fcontext-#{new_resource.secontext}-delete" do
    command "/usr/sbin/semanage fcontext -d '#{new_resource.file_spec}' && #{restorecon(new_resource.file_spec)}"
    only_if fcontext_defined(new_resource.file_spec, new_resource.secontext)
    only_if {use_selinux}
  end
end

action :modify do
  execute "selinux-fcontext-#{new_resource.secontext}-modify" do
    command "/usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}' && #{restorecon(new_resource.file_spec)}"
    only_if {use_selinux}
    only_if fcontext_defined(new_resource.file_spec)
    not_if  fcontext_defined(new_resource.file_spec, new_resource.secontext)
  end
end

action :addormodify do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  execute "selinux-fcontext-#{new_resource.secontext}-addormodify" do
    command "
    if #{fcontext_defined(new_resource.file_spec, new_resource.secontext)}; then
      /usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}' &&
      #{restorecon(new_resource.file_spec)}
    else
      /usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}' &&
      #{restorecon(new_resource.file_spec)}
    fi"
    not_if fcontext_defined(new_resource.file_spec, new_resource.secontext)
    only_if {use_selinux}
  end
end
