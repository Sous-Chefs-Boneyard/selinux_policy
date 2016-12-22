name             'selinux_policy'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'GPL v2'
description      'Manages SELinux policy components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.1'

attribute 'selinux_policy',
          display_name: 'SELinux Policy',
          description: 'Hash of SELinux policy related attributes',
          type: 'hash'

supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'ubuntu'
supports 'debian'

depends 'yum', '~> 4.0'

source_url 'https://github.com/sous-chefs/selinux_policy' if respond_to?(:source_url)
issues_url 'https://github.com/sous-chefs/selinux_policy/issues' if respond_to?(:issues_url)
chef_version '>= 11.0' if respond_to?(:chef_version)
