describe command('semodule -l') do
  its('stdout') { should match 'dirtest' }
end

%w(
  dirtest_t
  dirtest_exec_t
  dirtest_log_t
  dirtest_tmp_t
).each do |type|
  describe command("seinfo --type=#{type}") do
    its('stdout') { should match type }
    its('stderr') { should_not match "ERROR: could not find datum for type #{type}" }
  end
end

describe command('semanage fcontext -l') do
  its('stdout') { should match %r{/usr/bin/dirtest\s+regular file\s+system_u:object_r:dirtest_exec_t:s0} }
end

describe command('stat -c %C /usr/bin/dirtest') do
  its('stdout') { should match 'dirtest_exec_t' }
end
