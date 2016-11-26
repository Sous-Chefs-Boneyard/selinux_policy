name             'selinux_policy'
maintainer       'Backslasher'
maintainer_email 'nitz.raz@gmail.com'
license          'GPL v2'
description      'Manages SELinux policy components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.1'

issues_url 'https://github.com/BackSlasher/chef-selinuxpolicy/issues'
source_url 'https://github.com/BackSlasher/chef-selinuxpolicy'

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
