# selinux_policy_module

Manages compilation, installation, and removal of SELinux modules.

## Actions

| Action     | Description                                                                                                                                                          |
|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `:deploy`  | Default. Runs `fetch`, `compile`, `install` in that order.                                                                                                           |
| `:fetch`   | Prepares the module's files for compilation. Creates a file with the given content or uses `remote_directory` to fetch source files from a given cookbook.           |
| `:compile` | Translates a module's source files into a `$NAME.pp` file. Uses `make` logic for idempotence.                                                                        |
| `:install` | Adds a compiled module `.pp` file to the current policy. Only installs if the module was modified this run, `force` is set, or it's missing from the current policy. |
| `:remove`  | Removes a module.                                                                                                                                                    |                                                                                                                                              |                                                                                         |

> **Note:** Ideally, this could compare the existing module to the new one, but the `extract` capability was only added in [this commit from Aug 15 2016](https://github.com/SELinuxProject/selinux/commit/65c6325271b54d3de9c17352a57d469dfbd12729). Until this change has rolled out to all supported platforms, the logic needs to be ugly :(.

## Properties

| Property           | Type    | Default value   | Description                                                                                                                                          |
|--------------------|---------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `module_name`      | String  | Resource name   | Name of the module to install/remove.                                                                                                                |
| `directory`        | String  | Chef file cache | Directory where the module source files are stored before compilation.                                                                               |
| `content`          | String  |                 | Content of the `.te` source file for the module. Useful for simple modules, e.g. from `audit2allow`. Conflicts with `directory_source`.              |
| `directory_source` | String  |                 | Copies a module directory from the cookbook using `remote_directory`. Useful for more complex modules with multiple files. Conflicts with `content`. |
| `cookbook`         | String  |                 | Source cookbook for `directory_source` / `remote_directory`.                                                                                         |
| `force`            | Boolean | `false`         | Forces (re)install of the module. Breaks idempotence.                                                                                                |
| `allow_disabled`   | Boolean | `true`          | Whether to skip the resource if SELinux is not enabled.                                                                                              |

> **Note:** You can pre-create the module directory when using `directory_source` and populate it in any other way you'd choose.

## Examples

```ruby
include_recipe 'selinux_policy::install'

# Allow openvpn to write/delete in '/etc/openvpn'
selinux_policy_module 'openvpn-googleauthenticator' do
  content <<~EOM
    module dy-openvpn-googleauthenticator 1.0;

    require {
        type openvpn_t;
        type openvpn_etc_t;
        class file { write unlink };
    }


    #============= openvpn_t ==============
    allow openvpn_t openvpn_etc_t:file { write unlink };
  EOM
  action :deploy
end
```
