require 'chefspec'
require 'chefspec/berkshelf'

module ChefSpec
  class SoloRunner
    def converge_dsl(*recipes, &block)
      cookbook_name = 'imaginary'
      recipe_name = 'temp'
      converge(*recipes) do
        recipe = Chef::Recipe.new(cookbook_name, recipe_name, @run_context)
        recipe.instance_eval(&block)
      end
    end
  end
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
