require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new()

require 'foodcritic'
FoodCritic::Rake::LintTask.new()

require 'rubocop/rake_task'
RuboCop::RakeTask.new().tap{|rc|
  rc.options+= ['--fail-level', 'E']
}

namespace :testing do

  desc 'A set of tests for travis'
  task :travis => [:foodcritic, :rubocop, :spec]

end
