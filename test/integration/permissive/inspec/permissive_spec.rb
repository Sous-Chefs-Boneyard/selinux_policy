describe command('semanage permissive -l') do
  its('stdout') { should match 'httpd_t' }
  its('stdout') { should_not match 'user_t' }
end
