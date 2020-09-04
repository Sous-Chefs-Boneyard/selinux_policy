describe command('semodule -l') do
  its('stdout') { should_not match 'test_module' }
end

describe command('seinfo --type=test_module_t') do
  its('stdout') { should_not match 'test_module_t' }
  its('stderr') { should match 'ERROR: could not find datum for type test_module_t' }
end
