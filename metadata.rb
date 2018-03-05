name             'selinux_policy'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Manages SELinux policy components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/sous-chefs/selinux_policy'
issues_url       'https://github.com/sous-chefs/selinux_policy/issues'
chef_version     '>= 12.7' if respond_to?(:chef_version)
version          '2.0.1'

supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'ubuntu'
supports 'debian'
supports 'amazon'
