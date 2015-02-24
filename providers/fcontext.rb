# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

# Create if doesn't exist, do not touch if fcontext is already registered
action :add do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  noregex_file_spec = new_resource.file_spec.split(/(\(\/\.\*\)\?|\.\*)$/)[0]
  execute "selinux-fcontext-#{noregex_file_spec}-#{new_resource.secontext}-add" do
    command "/usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}' && restorecon -R #{noregex_file_spec}"
    not_if "/usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}.*#{new_resource.secontext}'>/dev/null"
  end
end

# Delete if exists
action :delete do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  noregex_file_spec = new_resource.file_spec.split(/(\(\/\.\*\)\?|\.\*)$/)[0]
  execute "selinux-fcontext-#{noregex_file_spec}-#{new_resource.secontext}-delete" do
    command "/usr/sbin/semanage fcontext -d '#{new_resource.file_spec}' && restorecon -R #{noregex_file_spec}"
    only_if "/usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}.*#{new_resource.secontext}'>/dev/null"
  end
end

action :modify do
  noregex_file_spec = new_resource.file_spec.split(/(\(\/\.\*\)\?|\.\*)$/)[0]
  execute "selinux-fcontext-#{noregex_file_spec}-#{new_resource.secontext}-modify" do
    command "/usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}' && restorecon -R #{noregex_file_spec}"
  end
end

action :addormodify do
  escaped_file_spec = Regexp.escape(new_resource.file_spec)
  noregex_file_spec = new_resource.file_spec.split(/(\(\/\.\*\)\?|\.\*)$/)[0]
  execute "selinux-fcontext-#{noregex_file_spec}-#{new_resource.secontext}-addormodify" do
    command <<-EOT
  if /usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}.*#{new_resource.secontext}'>/dev/null; then
    /usr/sbin/semanage fcontext -m -t #{new_resource.secontext} '#{new_resource.file_spec}'
    restorecon -R #{noregex_file_spec}
  else
    /usr/sbin/semanage fcontext -a -t #{new_resource.secontext} '#{new_resource.file_spec}'
    restorecon -R #{noregex_file_spec}
  fi
  EOT
  not_if "/usr/sbin/semanage fcontext -l | grep -P '#{escaped_file_spec}.*#{new_resource.secontext}'>/dev/null"
  end
end
