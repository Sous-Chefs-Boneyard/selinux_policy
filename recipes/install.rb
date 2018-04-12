case node['platform_family']
when 'debian'
  raise 'Install SELinux manually on Ubuntu. See https://wiki.ubuntu.com/SELinux' if node['platform'] == 'ubuntu'
  pkgs = ['policycoreutils', 'selinux-policy-dev', 'setools', 'make']
when 'rhel'
  case node['platform_version'].to_i
  when 6
    # selinux-policy-devel does not exist in RHEL6
    pkgs = ['policycoreutils-python', 'selinux-policy', 'setools-console', 'make']
  when 7
    pkgs = ['policycoreutils-python', 'selinux-policy-devel', 'setools-console', 'make']
  else
    raise 'Unknown version of RHEL/derivative, cannot determine required package names'
  end
when 'fedora'
  pkgs = ['policycoreutils-python', 'selinux-policy-devel', 'setools-console', 'make']
else
  raise 'Unknown distro, cannot determine required package names'
end

pkgs.each { |p| package p }
