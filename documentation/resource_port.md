# selinux_policy_port

Allows assigning a network port to a certain SELinux context. As explained [here](https://wiki.centos.org/HowTos/SELinux#Allowing_Access_to_a_Port), it can be useful for running a webserver on a non-standard port.

## Actions

| Action         | Description                                                                  |
|----------------|------------------------------------------------------------------------------|
| `:addormodify` | Default. Assigns the port to the right context regardless of previous state. |
| `:add`         | Assigns the port to the right context if not listed (only uses `-a`).        |
| `:modify`      | Changes the port's context if already listed (only uses `-m`).               |
| `:delete`      | Removes the port's context if listed (uses `-d`).                            |

## Properties

| Name             | Type    | Default value | Description                                             |
|------------------|---------|---------------|---------------------------------------------------------|
| `port`           | String  | Resource name | The port in question.                                   |
| `protocol`       | String  |               | Either `tcp` or `udp`.                                  |
| `secontext`      | String  |               | The SELinux context to assign the port to.              |
| `allow_disabled` | Boolean | `true`        | Whether to skip the resource if SELinux is not enabled. |

## Examples

```ruby
include_recipe 'selinux_policy::install'

# Allow nginx/apache to bind to port 5678 by giving it the http_port_t context
selinux_policy_port '5678' do
 protocol 'tcp'
 secontext 'http_port_t'
end
```
