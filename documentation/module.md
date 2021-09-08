# module

Manages SEModules

Actions:

- `fetch`: Prepares the module's files for compilation. Allow `remote_directory`-like behavior
- `compile`: Translates a module source directory into a `NAME.pp` file. Uses `make` logic for idempotence.
- `install`: Adds a compiled module (`pp`) to the current policy. Only installs if the module was modified this run, `force` is enabled or it's missing from the current policy. **Note:** I wish I could compare the existing module to the one generated, but the `extract` capability was only added in [Aug 15](https://github.com/SELinuxProject/selinux/commit/65c6325271b54d3de9c17352a57d469dfbd12729). I'll be happy to see a better idea.
- `deploy` (default): Runs `fetch`, `compile`, `install` in that order.
- `remove`: Removes a module.

Properties:

- `name`: The module name. Defaults to resource name.
- `directory`: Directory where module is stored. Defaults to a directory inside the Chef cache.
- `content`: The module content, can be extracted from `audit2allow -m NAME`. This can be used to create simple modules without using external files.
- `directory_source`: Copies files cookbook to the module directory (uses `remote_directory`). Allows keeping all of the module's source files in the cookbook. **Note:** You can pre-create the module directory and populate it in any other way you'd choose.
- `cookbook`: Modifies the source cookbook for the `remote_directory`.
- `force`: Installs the module even if it seems fine. Ruins idempotence but should help solve some weird cases.

Example usage:

```ruby
include_recipe 'selinux_policy::install'

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
