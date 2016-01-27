source "https://supermarket.getchef.com"

metadata

group :integration do
  cookbook 'selinux', git: 'https://github.com/jbartko/selinux.git', branch: 'feature/add-serverspec'
  cookbook 'selinux_policy_test', :path => './test/cookbooks/selinux_policy_test'
end
