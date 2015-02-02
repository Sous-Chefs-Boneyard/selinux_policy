selinuxpolicy CHANGELOG
=======================

This file is used to list changes made in each version of the selinuxpolicy cookbook.

0.5.0
-----

- [Wade Peacock] - Added include_recipe to default.rb
- [Wade Peacock] - Added RHEL 6 support
- [Wade Peacock] - Rewrote :add,delete,modify,addormodify actions in port provider
- [Wade Peacock] - Fixed whyrun support for port providers
- [Wade Peacock] - Rewrote :set action in boolean provider
- [Wade Peacock] - Remove :setpersist and added new attribute for persist to :set
- [Wade Peacock] - Added detection to both port and boolean providers to silently handle SELINUX in disabled mode
- [Wade Peacock] - Updated documentation

0.4.0
-----
- [backlasher] - Fixed foodcritic errors

0.3.0
-----
- [backlasher] - Fixed `install.rb` syntax. Now it actually works


0.2.0
-----
- [backlasher] - Added module resource. Currently supports deployment and removal (because that's what I need)
- [backlasher] - Added permissive resource

0.1.0
-----
- [backlasher] - Initial release of selinuxpolicy

