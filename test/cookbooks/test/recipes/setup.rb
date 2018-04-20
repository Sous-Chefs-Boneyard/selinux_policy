# Sets the machine up for selinux goodness

include_recipe 'selinux_policy::install'

execute 'reboot' do
  # not_if { "system(\"sestatus -v | grep enabled | grep SELinux\")" }
end
