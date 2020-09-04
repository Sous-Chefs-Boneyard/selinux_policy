action :install do
  case node['platform_family']
  when 'debian'
    raise 'Debian / Ubuntu are not supported by this cookbook'

  when 'rhel'
    case node['platform_version'].to_i
    when 6
      package %w(policycoreutils-python selinux-policy setools-console make)
    when 7
      package %w(policycoreutils-python selinux-policy-devel setools-console make)
    when 8
      package %w(policycoreutils-python-utils selinux-policy-devel setools-console make)
    else
      raise 'Unknown version of RHEL/derivative, cannot determine required packages'
    end

  when 'fedora'
    package %w(policycoreutils selinux-policy-devel setools-console make)

  else
    raise 'Unknown / unsupported platform, cannot determine required packages'
  end
end
