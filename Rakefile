require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :foodcritic do
  sh 'foodcritic .'
end

task :travis => [:spec, :foodcritic]
