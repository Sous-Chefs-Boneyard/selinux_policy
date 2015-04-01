name             'selinux_policy'
maintainer       'Backslasher'
maintainer_email 'nitz.raz@gmail.com'
license          'GPL v2'
description      'Manages SELinux policy components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.2'

attribute 'selinux_policy',
  :display_name => 'SELinux Policy',
  :description  => 'Hash of SELinux policy related attributes',
  :type         => 'hash'

%w{ redhat centos ubuntu debian }.each do |os|
  supports os
end
