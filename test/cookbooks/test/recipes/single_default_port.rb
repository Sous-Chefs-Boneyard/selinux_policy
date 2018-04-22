# Define a single default port

include_recipe 'selinux_policy::install'

execute 'setenforce 1' do
  not_if '[ "$(getenforce)" = "Enforcing" ]'
end

selinux_policy_port '10080' do
  protocol 'tcp'
  secontext 'http_port_t'
end
