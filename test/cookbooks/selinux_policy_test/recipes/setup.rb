# Sets the machine up for selinux goodness

include_recipe 'selinux_policy::install'

execute 'setenforce 1' do
  not_if '[ "$(getenforce)" = "Enforcing" ]'
end
