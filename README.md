# selinux_policy Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/java.svg)](https://supermarket.chef.io/cookbooks/java)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/java/master.svg)](https://circleci.com/gh/sous-chefs/java)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook can be used to manage SELinux policies and components (rather than just enable / disable enforcing). I made it because I needed some SELinux settings done, and the `execute`s started to look annoying.

## Requirements

Needs an SELinux policy active (so its values can be managed). Can work with a disabled SELinux system (see attribute `allow_disabled`), which will generate warnings and do nothing (but won't break the run). Also requires SELinux's management tools, namely `semanage`, `setsebool` and `getsebool`. Tools are installed by the `selinux_policy::install` recipe (for RHEL/Debian and the like).

### Chef Infra Client

- 15.3+

### Platforms

- redhat
- centos
- fedora
- ubuntu
- debian
- amazon

## Attributes

These attributes affect the way all of the resource behave.

- `node['selinux_policy']['allow_disabled']` - Whether to allow runs when SELinux is disabled. Will generate warnings, but the run won't fail. Defaults to `true`, set to `false` if you don't have any machines with disabled SELinux.

## Usage

- `selinux_policy::install` - Installs SELinux policy management tools

This cookbook's functionality is exposed via resources, so it should be called from a wrapper cookbook. Remember to add `depends 'selinux_policy'` to your `metadata.rb`.

## Resources

- [boolean](documentation/boolean.md)
- [fcontext](documentation/fcontext.md)
- [module](documentation/module.md)
- [permissive](documentation/permissive.md)
- [port](documentation/port.md)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
