# A resource for managing SE modules

actions :deploy, :fetch, :compile, :install, :remove
default_action :deploy

attribute :name, :kind_of => String, :name_attribute => true
attribute :content, :kind_of => String, :default => nil
attribute :force, :kind_of => [ TrueClass, FalseClass ], :default => false
