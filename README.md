selinuxpolicy Cookbook
======================
This cookbbok can be used to manage SELinux policies and components (rather than just enable / disable it).  
I made it because I needed some SELinux settings done, and the `execute`s started to look annoying.

Requirements
------------
Needs a healthy SELinux installation.  
I'm not an expert on what makes SELinux "healthy", but you get the general idea

Attributes
----------
None, at the moment

Usage
-----

This cookbook only has resources, so it should be called from a wrapper cookbook.
Remember to add `depends 'selinuxpolicy'` to your `metadata.rb`

### boolean
Represents an SELinux [boolean](http://wiki.gentoo.org/wiki/SELinux/Tutorials/Using_SELinux_booleans).
You can either `set` it, meaning it will be changed without persistence (meaning it will revert to default in the next reboot), or `setpersist` it (default), so it'll keep it value after rebooting.  
Using `setpersist` requires an active policy (so that the new value can be saved somewhere).

Attributes:
* `name`: boolean's name. Defaults to resource name
* `value`: Its new value (`true`/`false`)
* `force`: Use `setsebool` even if the current value agrees with the requested one

Example usage:
    ::ruby
        selinuxpolicy_boolean 'httpd_can_network_connect' do
        value true
        # Make sure nginx is started if this value was modified
        notifies :start,'service[nginx]', :immediate
    end

**Note**: Due to ruby interperting `0` as `true`, using `value 0` is unwise.

### port
Allows assigning a network port to a certain SELinux context.  
As explained [here](http://wiki.centos.org/HowTos/SELinux#head-ad837f60830442ae77a81aedd10c20305a811388), it's useful for running Apache on a non-standard port, for instance.

Actions:
* `addormodify` (default): Assigns the port to the right context, whether it's already listed another context or not at all.
* `add`: Assigns the port to the right context it's if not listed (only uses `-a`)
* `modify`: Changes the port's context if it's already listed (only uses `-m`)
* `delete`: Removes the port's context if it's listed (uses `-d`)

Attributes:
* `port`: The port in question, defaults to resource name
* `protocol`: `tcp`/`udp`
* `secontext`: The SELinux context to assign the port to. Uneeded when using `delete`

Example usage:

    :::ruby
    # Allow nginx to bind to port 5678, by giving it the http_port_t context
    selinuxpolicy_port '1234' do
      protocol 'tcp'
      secontext 'http_port_t'
    end

Contributing
------------
The generic method seems fine to me:

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Licensed [GPL v2](http://choosealicense.com/licenses/gpl-2.0/)  
Author: Nitzan Raz ([backslasher](http://backslasher.net))  

I'll be happy to accept contributions or to hear from you!
