# boolean

Represents an SELinux [boolean](http://wiki.gentoo.org/wiki/SELinux/Tutorials/Using_SELinux_booleans). You can either `set` it, meaning it will be changed without persistence (it will revert to default in the next reboot), or `setpersist` it (default action), so it'll keep it value after rebooting. Using `setpersist` requires an active policy (so that the new value can be saved somewhere).

Properties:

- `name`: boolean's name. Defaults to resource name.
- `value`: Its new value (`true`/`false`).
- `force`: Use `setsebool` even if the current value agrees with the requested one.

Example usage:

```ruby
include_recipe 'selinux_policy::install'

selinux_policy_boolean 'httpd_can_network_connect' do
    value true
    # Make sure nginx is started if this value was modified
    notifies :start,'service[nginx]', :immediate
end
```

**Note**: Due to ruby interperting `0` as `true`, using `value 0` is unwise.
