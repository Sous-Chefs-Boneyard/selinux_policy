selinuxpolicy CHANGELOG
=======================

This file is used to list changes made in each version of the selinuxpolicy cookbook.

1.0.0
-----
- [Wade Peacock] - Added include_recipe to default.rb
- [Wade Peacock] - Added RHEL 6 support
- [Wade Peacock] - Rewrote :add,delete,modify,addormodify actions in port provider
- [Wade Peacock] - Fixed whyrun support for port providers
- [Wade Peacock] - Rewrote :set action in boolean provider
- [Wade Peacock] - Remove :setpersist and added new attribute for persist to :set
- [Wade Peacock] - Added detection to both port and boolean providers to silently handle SELINUX in disabled mode
- [Wade Peacock] - Updated documentation 

0.1.0
-----
- [backlasher] - Initial release of selinuxpolicy

