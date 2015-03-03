# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

# Create if doesn't exist, do not touch if fcontext is already registered
action :add do
  if use_selinux then
    escaped_file_spec = Regexp.escape(new_resource.file_spec)
    execute "selinux-fcontext-#{new_resource.secontext}-add" do
      command lazy { "/usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}' && #{restorecon(new_resource.file_spec)}" }
      not_if "/usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}\s.*\ssystem_u:object_r:#{new_resource.secontext}:s0'>/dev/null"
    end
  end
end

# Delete if exists
action :delete do
  if use_selinux then
    escaped_file_spec = Regexp.escape(new_resource.file_spec)
    execute "selinux-fcontext-#{new_resource.secontext}-delete" do
      command lazy { "/usr/sbin/semanage fcontext -d '#{new_resource.file_spec}' && #{restorecon(new_resource.file_spec)}" }
      only_if "/usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}\s.*\ssystem_u:object_r:#{new_resource.secontext}:s0'>/dev/null"
    end
  end
end

action :modify do
  if use_selinux then
    execute "selinux-fcontext-#{new_resource.secontext}-modify" do
      command lazy { "/usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}' && #{restorecon(new_resource.file_spec)}" }
    end
  end
end

action :addormodify do
  if use_selinux then
    escaped_file_spec = Regexp.escape(new_resource.file_spec)
    execute "selinux-fcontext-#{new_resource.secontext}-addormodify" do
      command lazy { "
      if /usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}\s.*'>/dev/null; then
        /usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}'
        #{restorecon(new_resource.file_spec)}
      else
        /usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}'
        #{restorecon(new_resource.file_spec)}
      fi" }
      not_if "/usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}\s.*\ssystem_u:object_r:#{new_resource.secontext}:s0'>/dev/null"
    end
  end
end
