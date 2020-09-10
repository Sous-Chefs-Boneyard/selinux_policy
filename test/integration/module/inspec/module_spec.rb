describe command('semodule -l') do
  its('stdout') { should match 'test_module' }
end

describe command('seinfo --type=test_module_t') do
  its('stdout') { should match 'test_module_t' }
end
