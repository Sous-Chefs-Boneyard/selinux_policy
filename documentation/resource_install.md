# selinux_policy_install

Installs the required packages and tools to setup a working SELinux environment. A reboot may be required to fully enable SELinux.

## Actions

| Action     | Description                            |
|------------|----------------------------------------|
| `:install` | Default. Installs the needed packages. |

## Properties

None.

## Examples

```ruby
selinux_policy_install 'example' do
  notifies :reboot_now, 'reboot[selinux-reboot]', :immediately
end

reboot 'selinux-reboot' do
  action :nothing
  reason 'Rebooting to enable SELinux.'
end
```
