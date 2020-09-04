selinux_policy_boolean 'httpd_can_network_connect' do
  value true
end

selinux_policy_boolean 'httpd_enable_cgi' do
  value false
end
