# permissive

Allows some types to misbehave without stopping them. Not as good as specific policies, but better than disabling SELinux entirely.

Actions:

- `add`: Adds a permissive, unless it's already added
- `delete`: Deletes a permissive if it's listed

Example usage:

```ruby
include_recipe 'selinux_policy::install'

# Disable enforcement on Nginx
# As described on http://nginx.com/blog/nginx-se-linux-changes-upgrading-rhel-6-6/

selinux_policy_permissive 'nginx' do
  notifies :restart, 'service[nginx]'
end
```
