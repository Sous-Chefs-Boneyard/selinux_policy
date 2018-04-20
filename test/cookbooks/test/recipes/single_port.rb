# Define a single port
selinux_policy_port '1080' do
  protocol 'tcp'
  secontext 'http_port_t'
end
