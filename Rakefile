require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :foodcritic do
  sh 'foodcritic .'
end

task :rubocop do
  sh "rubocop --fail-level E"
end

task :travis => [:spec, :foodcritic, :rubocop]
