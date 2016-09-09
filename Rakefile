require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'foodcritic'
FoodCritic::Rake::LintTask.new()


namespace :testing do

  desc 'run Rubocop'
  task :rubocop do
    sh "rubocop --fail-level E"
  end

  desc 'A set of tests for travis'
  task :travis => [:spec, :foodcritic, :rubocop]

end
