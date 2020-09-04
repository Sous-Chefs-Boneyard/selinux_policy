selinux_policy_module 'test_module' do
  content <<~EOM
    policy_module(test_module, 0.0.1)
    type test_module_t;
  EOM
end

selinux_policy_module 'test_module' do
  action :remove
end
