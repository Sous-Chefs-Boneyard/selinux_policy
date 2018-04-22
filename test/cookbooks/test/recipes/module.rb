# Plays around with an SEModule

module_content = <<-eos
  policy_module(testy, 1.0.0)
  type testy_t;
eos

selinux_policy_module 'testy' do
  content module_content
end

# Should not be reinstalled
selinux_policy_module 'testy-again' do
  module_name 'testy'
  content module_content
end

selinux_policy_module 'testy-bye' do
  action :remove
  module_name 'testy'
end
