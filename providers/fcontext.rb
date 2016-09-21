include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

def fcontext_defined(file_spec, label = nil)
  base_command = "semanage fcontext -l | grep -P '^#{Regexp.escape(file_spec)}\\s'"
  if label
    "#{base_command} | grep -P '\\ssystem_u:object_r:#{Regexp.escape(label)}:s0\\s*$'"
  else
    base_command
  end
end

def restorecon(file_spec)
  path = file_spec.to_s.sub(/\\/, '') # Remove backslashes
  return "restorecon -i #{path}" if ::File.exist?(path) # Return if it's not a regular expression
  path.count('/').times do
    path = ::File.dirname(path) # Splits at last '/' and returns front part
    break if ::File.directory?(path)
  end
  # This will restore the selinux file context recursively.
  "restorecon -iR #{path}"
end

use_inline_resources

# Run restorecon to fix label
action :relabel do
  execute "selinux-fcontext-relabel-#{new_resource.secontext}" do
    command restorecon(new_resource.file_spec)
    not_if "test -z \"$(#{restorecon(new_resource.file_spec)} -vn)\""
  end
end

# Create if doesn't exist, do not touch if fcontext is already registered
action :add do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  execute "selinux-fcontext-#{new_resource.secontext}-add" do
    command "/usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}'"
    not_if fcontext_defined(new_resource.file_spec)
    only_if { use_selinux }
    notifies :relabel, new_resource, :immediate
  end
end

# Delete if exists
action :delete do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  execute "selinux-fcontext-#{new_resource.secontext}-delete" do
    command "/usr/sbin/semanage fcontext -d '#{new_resource.file_spec}'"
    only_if fcontext_defined(new_resource.file_spec, new_resource.secontext)
    only_if { use_selinux }
    notifies :relabel, new_resource, :immediate
  end
end

action :modify do
  execute "selinux-fcontext-#{new_resource.secontext}-modify" do
    command "/usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}'"
    only_if { use_selinux }
    only_if fcontext_defined(new_resource.file_spec)
    not_if  fcontext_defined(new_resource.file_spec, new_resource.secontext)
    notifies :relabel, new_resource, :immediate
  end
end

action :addormodify do
  run_action(:add)
  run_action(:modify)
end
