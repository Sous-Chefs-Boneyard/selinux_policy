require 'rake'

# Run command wrapper
def run_command(command)
  if File.exist?('Gemfile.lock')
    sh %(bundle exec #{command})
  else
    sh %(chef exec #{command})
  end
end

desc 'Run RuboCop (cookstyle) tests'
task :style do
  run_command('cookstyle')
end

desc 'Run FoodCritic (lint) tests'
task :lint do
  run_command('foodcritic --epic-fail any .')
end

desc 'Run RSpec (unit) tests'
task :unit do
  run_command('rm -f Berksfile.lock')
  run_command('rspec --format documentation --color')
end

desc 'Run all tests'
task test: [:style, :lint, :unit]

task default: :test
