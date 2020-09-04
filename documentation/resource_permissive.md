# selinux_policy_permissive

Allows some types to misbehave without stopping them. Not as good as specific policies, but better than disabling SELinux entirely.

## Actions

| Action    | Description                                     |
|-----------|-------------------------------------------------|
| `:add`    | Default. Adds a permissive, unless already set. |
| `:delete` | Removes a permissive, if set.                   |

## Properties

| Name             | Type    | Default       | Description                                             |
|------------------|---------|---------------|---------------------------------------------------------|
| `context`           | String  | Resource name | Name of the context to disable SELinux for.             |
| `allow_disabled` | Boolean | `true`        | Whether to skip the resource if SELinux is not enabled. |

## Examples

```ruby
include_recipe 'selinux_policy::install'

# Disable enforcement on Apache
selinux_policy_permissive 'httpd_t' do
  notifies :restart, 'service[httpd]'
end
```
