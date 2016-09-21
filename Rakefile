require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'foodcritic'
FoodCritic::Rake::LintTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new.tap do |rc|
  rc.options += ['--fail-level', 'E']
end

# Only load kitchen tasks if we have kitchen available
got_kitchen = begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
  true
rescue LoadError, Kitchen::UserError
  # Not loading kitchen specs
  false
end
if got_kitchen
  kitchen_instance_tasks = Rake::Task['kitchen:all'].prerequisites.map { |n| "kitchen:#{n}" }
else
  kitchen_instance_tasks = []
end

namespace :testing do
  desc 'A set of tests for travis'
  task travis: [:foodcritic, :rubocop, :spec]

  desc 'Full testing of kitchen'
  multitask kitchen: kitchen_instance_tasks do
    raise 'No kitchen tests to run' unless kitchen_instance_tasks.any?
  end

  desc 'Tests a user should run'
  task user: [:foodcritic, :rubocop, :spec, :kitchen]
end
