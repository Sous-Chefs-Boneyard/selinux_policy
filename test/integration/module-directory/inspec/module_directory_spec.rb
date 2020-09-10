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
  end
end

describe command('semanage fcontext -l') do
  its('stdout') { should match %r{/usr/bin/dirtest\s+regular file\s+system_u:object_r:dirtest_exec_t:s0} }
end
