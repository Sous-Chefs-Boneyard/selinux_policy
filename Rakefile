require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

namespace :testing do

  desc 'run Foodcritic'
  task :foodcritic do
    sh 'foodcritic .'
  end

  desc 'run Rubocop'
  task :rubocop do
    sh "rubocop --fail-level E"
  end

  desc 'A set of tests for travis'
  task :travis => [:spec, :foodcritic, :rubocop]

end
