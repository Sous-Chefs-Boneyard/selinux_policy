# Manages file specs in SELinux
# See http://docs.fedoraproject.org/en-US/Fedora/13/html/SELinux_FAQ/index.html#id3715134

property :file_spec, String, name_property: true
property :secontext, String
property :file_type, String, default: 'a', equal_to: %w(a f d c b s l p)
property :allow_disabled, [true, false], default: true

action :addormodify do
  run_action(:add)
  run_action(:modify)
end

# Run restorecon to fix label
# https://github.com/sous-chefs/selinux_policy/pull/72#issuecomment-338718721
action :relabel do
  spec = new_resource.file_spec
  escaped = Regexp.escape spec

  # find common path between regex and string
  common = if spec == escaped
             spec
           else
             index = spec.size.times { |i| break i if spec[i] != escaped[i] }
             ::File.dirname spec[0...index]
           end

  # if path is not absolute, ignore it and search everything
  common = '/' if common[0] != '/'

  execute 'selinux-fcontext-relabel' do
    command "find #{common.shellescape} -ignore_readdir_race -regextype posix-egrep -regex #{spec.shellescape} -prune -print0 2>/dev/null | xargs -0 restorecon -iRv"
    only_if { ::File.exist? common }
  end
end

# Create if doesn't exist, do not touch if fcontext is already registered
action :add do
  execute "selinux-fcontext-#{new_resource.secontext}-add" do
    command "#{semanage_cmd} fcontext -a #{semanage_options(new_resource.file_type)} -t #{new_resource.secontext} '#{new_resource.file_spec}'"
    not_if fcontext_defined(new_resource.file_spec, new_resource.file_type)
    only_if { use_selinux(new_resource.allow_disabled) }
    notifies :relabel, new_resource, :immediately
  end
end

# Delete if exists
action :delete do
  execute "selinux-fcontext-#{new_resource.secontext}-delete" do
    command "#{semanage_cmd} fcontext #{semanage_options(new_resource.file_type)} -d '#{new_resource.file_spec}'"
    only_if fcontext_defined(new_resource.file_spec, new_resource.file_type, new_resource.secontext)
    only_if { use_selinux(new_resource.allow_disabled) }
    notifies :relabel, new_resource, :immediately
  end
end

action :modify do
  execute "selinux-fcontext-#{new_resource.secontext}-modify" do
    command "#{semanage_cmd} fcontext -m #{semanage_options(new_resource.file_type)} -t #{new_resource.secontext} '#{new_resource.file_spec}'"
    only_if fcontext_defined(new_resource.file_spec, new_resource.file_type)
    not_if  fcontext_defined(new_resource.file_spec, new_resource.file_type, new_resource.secontext)
    only_if { use_selinux(new_resource.allow_disabled) }
    notifies :relabel, new_resource, :immediately
  end
end
