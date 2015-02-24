selinuxpolicy CHANGELOG
=======================

This file is used to list changes made in each version of the selinuxpolicy cookbook.

0.5.0
-----
- [backslasher] - Added RHEL5/derivatives support. Thanks to @knightorc.
                  Cookbook will break on RHEL7. If anyone expiriences this, please check required packages and create an issue/PR
- [backslasher] - Machines without SELinux are (opionally) supported. Thanks to @knightroc.

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

