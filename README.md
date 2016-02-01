SELinux Policy Cookbook
======================
This cookbbok can be used to manage SELinux policies and components (rather than just enable / disable enforcing).  
I made it because I needed some SELinux settings done, and the `execute`s started to look annoying.

Requirements
------------
Needs an SELinux policy active (so its values can be managed). Can work with a disabled SELinux system (see attribute `allow_disabled`), which will generate warnings and do nothing (but won't break the run).  
Also requires SELinux's management tools, namely `semanage`, `setsebool` and `getsebool`.
Tools are installed by the `selinux_policy::install` recipe (for RHEL/Debian and the like).

Attributes
----------

These attributes affect the way all of the LWRPs are behaving.

* `node['selinux_policy']['allow_disabled']` - Whether to allow runs when SELinux is disabled. Will generate warnings, but the run won't fail.  
   Defaults to `true`, set to `false` if you don't have any machines with disabled SELinux.


Usage
-----

This cookbook's functionality is exposed via resources, so it should be called from a wrapper cookbook.
Remember to add `depends 'selinux_policy'` to your `metadata.rb`.

### boolean
Represents an SELinux [boolean](http://wiki.gentoo.org/wiki/SELinux/Tutorials/Using_SELinux_booleans).
You can either `set` it, meaning it will be changed without persistence (it will revert to default in the next reboot), or `setpersist` it (default action), so it'll keep it value after rebooting.  
Using `setpersist` requires an active policy (so that the new value can be saved somewhere).

Attributes:

* `name`: boolean's name. Defaults to resource name.
* `value`: Its new value (`true`/`false`).
* `force`: Use `setsebool` even if the current value agrees with the requested one.

Example usage:

```ruby
selinux_policy_boolean 'httpd_can_network_connect' do
    value true
    # Make sure nginx is started if this value was modified
    notifies :start,'service[nginx]', :immediate
end
```

**Note**: Due to ruby interperting `0` as `true`, using `value 0` is unwise.

### port
Allows assigning a network port to a certain SELinux context.  
As explained [here](http://wiki.centos.org/HowTos/SELinux#head-ad837f60830442ae77a81aedd10c20305a811388), it can be useful for running Apache on a non-standard port.

Actions:

* `addormodify` (default): Assigns the port to the right context, whether it's already listed another context or not at all.
* `add`: Assigns the port to the right context it's if not listed (only uses `-a`).
* `modify`: Changes the port's context if it's already listed (only uses `-m`).
* `delete`: Removes the port's context if it's listed (uses `-d`).

Attributes:

* `port`: The port in question, defaults to resource name.
* `protocol`: `tcp`/`udp`.
* `secontext`: The SELinux context to assign the port to. Uneeded when using `delete`.

Example usage:

```ruby
# Allow nginx to bind to port 5678, by giving it the http_port_t context
selinux_policy_port '5678' do
    protocol 'tcp'
    secontext 'http_port_t'
end
```

### module
Manages SEModules

Actions:

* `fetch`: Prepares the module's files for compilation. Allow `remote_directory`-like behaviour
* `compile`: Translates a module source directory into a `NAME.pp` file. Uses `make` logic for idempotence.
* `install`: Adds a compiled module (`pp`) to the current policy. Only installs if the module was modified this run, `force` is enabled or it's missing from the current policy.  
    **Note:** I wish I could compare the existing module to the one generated, but the `extract` capability was only added in [Aug 15](https://github.com/SELinuxProject/selinux/commit/65c6325271b54d3de9c17352a57d469dfbd12729). I'll be happy to see a better idea.
* `deploy` (default): Runs `fetch`, `compile`, `install` in that order.
* `remove`: Removes a module.

Attributes:

* `name`: The module name. Defaults to resource name.
* `directory`: Directory where module is stored. Defaults to a directory inside the Chef cache.
* `content`: The module content, can be extracted from `audit2allow -m NAME`. This can be used to create simple modules without using external files.
* `directory_source`: Copies files cookbook to the module directory (uses `remote_directory`). Allows keeping all of the module's source files in the cookbook.  
    **Note:** You can pre-create the module directory and populate it in any other way you'd choose.
* `cookbook`: Modifies the source cookbook for the `remote_directory`.
* `force`: Installs the module even if it seems fine. Ruins idempotence but should help solve some weird cases.

Example usage:

```ruby
# Allow openvpn to write/delete in '/etc/openvpn'
selinux_policy_module 'openvpn-googleauthenticator' do
  content <<-eos
    module dy-openvpn-googleauthenticator 1.0;

    require {
        type openvpn_t;
        type openvpn_etc_t;
        class file { write unlink };
    }


    #============= openvpn_t ==============
    allow openvpn_t openvpn_etc_t:file { write unlink };
  eos
  action :deploy
end
```
### fcontext
Allows managing the SELinux context of files.
This can be used to grant SELinux-protected daemons access to additional / moved files.

Actions:

* `addormodify` (default): Assigns the file regexp to the right context, whether it's already listed another context or not at all.
* `add`: Assigns the file regexp to the right context it's if not listed (only uses -a).
* `modify`: Changes the file regexp context if it's already listed (only uses -m).
* `delete`: Removes the file regexp context if it's listed (uses -d).

Attributes:

* `file_spec`: This is the file regexp in question, defaults to resource name.
* `secontext`: The SELinux context to assign the file regexp to. Not required for `:delete`

Example usage (see mysql cookbook for example daemons ):

```ruby
# Allow http servers (nginx/apache) to modify moodle files
selinux_policy_fcontext '/var/www/moodle(/.*)?' do
  secontext 'httpd_sys_rw_content_t'
end

# Allow a custom mysql daemon to access its files.
{'mysqld_etc_t' => "/etc/mysql-#{service_name}(/.*)?",
'mysqld_etc_t' => "/etc/mysql-#{service_name}/my\.cnf",
'mysqld_log_t' => "/var/log/mysql-#{service_name}(/.*)?",
'mysqld_db_t' => "/opt/mysql_data_#{service_name}(/.*)?",
'mysqld_var_run_t' => "/var/run/mysql-#{service_name}(/.*)?",
'mysqld_initrc_exec_t' => "/etc/rc\.d/init\.d/mysql-#{service_name}"}.each do |sc, f|
  selinux_policy_fcontext f do
    secontext sc
  end
end
```

### permissive
Allows some types to misbehave without stopping them.  
Not as good as specific policies, but better than disabling SELinux entirely.

Actions:

* `add`: Adds a permissive, unless it's already added
* `delete`: Deletes a permissive if it's listed

Example usage:

```ruby
# Disable enforcement on Nginx
# As described on http://nginx.com/blog/nginx-se-linux-changes-upgrading-rhel-6-6/

selinux_policy_permissive 'nginx' do
  notifies :restart, 'service[nginx]'
end
```

## Testing
We have a test kitchen that has *some* tests (at the time of writing this: Basic port ops)  
We also have a ChefSpec suite for *some* things (again, currently only basic ports). To use it, run something like `chef exec rspec`.  
We also only test against CentOS (because Ubuntu comes with SELinux disabled and restarting mid-test is hard).  

## Chef 11 Support
I don't use Chef 11, but stuff *seems* to work OK to other people.

## Contributing
Pretty standard.  
If fixing a bug, please add regession tests to the RSpec (if applicable) and the kitchen.  
If adding a feature, please create basic tests for it, both RSpec and kitchen.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Licensed [GPL v2](http://choosealicense.com/licenses/gpl-2.0/)  
Author: [Nitzan Raz](https://github.com/BackSlasher) ([backslasher](http://backslasher.net))

Contributors:
* [Joerg Herzinger](https://github.com/joerg) (http://www.bytesource.net)
* [Wade Peacock](https://github.com/knightorc) (http://www.visioncritical.com)
* [Kieren Evans](https://github.com/kierenevans) (http://kle.me)
* [Antek Baranski](https://github.com/Sauraus)
* [James Le Cuirot](https://github.com/chewi)
* [John Bartko](https://github.com/jbartko)
* [Maksim Horbul](https://github.com/mhorbul)

I'll be happy to accept contributions or to hear from you!
