# Manages file specs in SELinux
# See http://docs.fedoraproject.org/en-US/Fedora/13/html/SELinux_FAQ/index.html#id3715134

actions :add, :delete, :modify, :addormodify, :relabel
default_action :addormodify
attribute :file_spec, kind_of: String, name_attribute: true
attribute :secontext, kind_of: String
