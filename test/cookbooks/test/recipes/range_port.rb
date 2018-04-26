# Ensures a port is correctly detected when a range is already defined

# Manually define ports
execute 'semanage port -a -t http_port_t  -p tcp 1900-1902' do
  not_if 'semanage port -l | grep http_port_t | grep 1900-1902'
end
