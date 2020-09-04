# selinux_policy_boolean

Represents an SELinux [boolean](http://wiki.gentoo.org/wiki/SELinux/Tutorials/Using_SELinux_booleans).

## Actions

| Action        | Description                                                                    |
|---------------|--------------------------------------------------------------------------------|
| `:setpersist` | Default. The new value will persist across reboots. Requires an active policy. |
| `:set`        | Sets new value without persistence. Reverts to the default value on reboot.    |

## Properties

| Name             | Type    | Default value | Description                                                                       |
|------------------|---------|---------------|-----------------------------------------------------------------------------------|
| `name`           | String  | Resource name | Name of the SELinux boolean                                                       |
| `value`          | Boolean |               | The value to set                                                                  |
| `force`          | Boolean | `false`       | Whether to set even if the current value matches the new one. Breaks idempotency. |
| `allow_disabled` | Boolean | `true`        | Whether to skip the resource if SELinux is not enabled.                           |

## Examples

```ruby
include_recipe 'selinux_policy::install'

selinux_policy_boolean 'httpd_can_network_connect' do
    value true
    # Make sure nginx is started if this value was modified
    notifies :start,'service[nginx]', :immediate
end
```
