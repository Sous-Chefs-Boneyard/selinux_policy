describe command('getsebool httpd_can_network_connect') do
  its('stdout') { should match 'httpd_can_network_connect --> on' }
end

describe command('getsebool httpd_enable_cgi') do
  its('stdout') { should match 'httpd_enable_cgi --> off' }
end
