# selinux_policy Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/selinux_policy.svg)](https://supermarket.chef.io/cookbooks/selinux_policy)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook can be used to manage SELinux policies and components.

## Requirements

Needs an active SELinux policy (so its values can be managed) and management tools, namely `semanage`, `setsebool` and `getsebool`. Tools are installed by the `selinux_policy_install` resource.

If this cookbook needs to run on a node with SELinux disabled, set the `allow_disabled` property on resources to `true`, which will skip the resource and do nothing (but won't break the run).

### Chef Infra Client

- 15 or later

### Platforms

- CentOS 7+
- Fedora latest

## Usage

This cookbook's functionality is exposed via resources, so it should be called from a wrapper cookbook. Remember to add `depends 'selinux_policy'` to your `metadata.rb`.

## Recipes

- `selinux_policy::default`: Does nothing.
- `selinux_policy::install`: Calls `selinux_policy_install`.

## Resources

- [`selinux_policy_install`](documentation/resource_install.md)
- [`selinux_policy_boolean`](documentation/resource_boolean.md)
- [`selinux_policy_fcontext`](documentation/resource_fcontext.md)
- [`selinux_policy_module`](documentation/resource_module.md)
- [`selinux_policy_permissive`](documentation/resource_permissive.md)
- [`selinux_policy_port`](documentation/resource_port.md)

## Contributors

Original author: [Nitzan Raz](https://github.com/BackSlasher) ([backslasher](http://backslasher.net))

Tests & documentation: [Robert Detjens](https://github.com/detjensrobert)
