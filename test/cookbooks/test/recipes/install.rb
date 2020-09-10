selinux_policy_install 'install' do
  notifies :reboot_now, 'reboot[SELinux Reboot]', :immediately
end

reboot 'SELinux Reboot' do
  action :nothing
  reason 'Rebooting to enable SELinux.'
  not_if "sestatus | grep -qEi 'SELinux status:\s+enabled'"
end
