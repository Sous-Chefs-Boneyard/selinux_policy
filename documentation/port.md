# port

Allows assigning a network port to a certain SELinux context. As explained [here](http://wiki.centos.org/HowTos/SELinux#head-ad837f60830442ae77a81aedd10c20305a811388), it can be useful for running Apache on a non-standard port.

Actions:

- `addormodify` (default): Assigns the port to the right context, whether it's already listed another context or not at all.
- `add`: Assigns the port to the right context it's if not listed (only uses `-a`).
- `modify`: Changes the port's context if it's already listed (only uses `-m`).
- `delete`: Removes the port's context if it's listed (uses `-d`).

Properties:

- `port`: The port in question, defaults to resource name.
- `protocol`: `tcp`/`udp`.
- `secontext`: The SELinux context to assign the port to. Unnecessary when using `delete`.

Example usage:

```ruby
include_recipe 'selinux_policy::install'

# Allow nginx to bind to port 5678, by giving it the http_port_t context
selinux_policy_port '5678' do
    protocol 'tcp'
    secontext 'http_port_t'
end
```
