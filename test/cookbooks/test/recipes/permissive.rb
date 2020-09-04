selinux_policy_permissive 'httpd_t'

selinux_policy_permissive 'user_t' do
  action :delete
end
