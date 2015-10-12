# Cookbook: selinux_policy
# Attribute file: default
# 2015, GPLv2, Nitzan Raz (http://backslasher.net)

default['selinux_policy']['allow_disabled']=true
default['selinux_policy']['script_location'] = "#{Chef::Config[:file_cache_path]}/selinux_policy/helper_scripts"
