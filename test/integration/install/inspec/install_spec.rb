describe command('sestatus') do
  its('stdout') { should cmp /SELinux status:\s+enabled/ }
end

describe command('getenforce') do
  its('stdout') { should cmp /Enforcing|Permissive/ }
  its('stdout') { should_not cmp /Disabled/ }
end
