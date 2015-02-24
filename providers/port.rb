# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

# Create if doesn't exist, do not touch if port is already registered (even under different type)
action :add do
  if use_selinux then
    execute "selinux-port-#{new_resource.port}-add" do
      command "/usr/sbin/semanage port -a -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
      not_if "/usr/sbin/semanage port -l | grep -P '#{new_resource.protocol}\\s+#{new_resource.port}'>/dev/null"
    end
  end
end

# Delete if exists
action :delete do
  if use_selinux then
    execute "selinux-port-#{new_resource.port}-delete" do
      command "/usr/sbin/semanage port -d -p #{new_resource.protocol} #{new_resource.port}"
      only_if "/usr/sbin/semanage port -l | grep -P '#{new_resource.protocol}\\s+#{new_resource.port}'>/dev/null"
    end
  end
end

action :modify do
  if use_selinux then
    execute "selinux-port-#{new_resource.port}-modify" do
      command "/usr/sbin/semanage port -m -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}"
    end
  end
end

action :addormodify do
  if use_selinux then
    execute "selinux-port-#{new_resource.port}-addormodify" do
      command <<-EOT
    if /usr/sbin/semanage port -l | grep -P '#{new_resource.protocol}\\s+#{new_resource.port}'>/dev/null; then
      /usr/sbin/semanage port -m -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}
    else
      /usr/sbin/semanage port -a -t #{new_resource.secontext} -p #{new_resource.protocol} #{new_resource.port}
    fi
    EOT
    not_if "/usr/sbin/semanage port -l | grep -P '#{new_resource.secontext}\\s+#{new_resource.protocol}\\s+#{new_resource.port}'>/dev/null"
    end
  end
end
