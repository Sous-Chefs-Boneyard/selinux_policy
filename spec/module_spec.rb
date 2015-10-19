require 'chefspec'

module ChefSpec
  class SoloRunner
    def converge_dsl(*recipes,&block)
      cookbook_name = 'imaginary'
      recipe_name = 'temp'
      converge(*recipes){
        recipe = Chef::Recipe.new(cookbook_name, recipe_name, @run_context)
        recipe.instance_eval(&block)
      }
    end
  end
end


describe 'selinux_policy module' do
  describe 'Deploy' do
    let :chef_run do
      ChefSpec::SoloRunner.new(step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
        node.override['selinux_policy']['allow_disabled'] = false
        selinux_policy_module 'testy' do
          content '
  policy_module(testy, 1.0.0)
  type testy_t;
  '
        end
      end
    end
    it 'creates when none' do
      stub_command("/usr/sbin/semodule -l | grep -w '^testy'").and_return(false)
      expect(chef_run).to run_execute('semodule-deploy-testy')
    end
    it 'does nothing when match' do
      stub_command("/usr/sbin/semodule -l | grep -w '^testy'").and_return(true)
      #XXX broken because can't manipulate file resource properly
    end
  end

  describe 'Remove' do
    let :chef_run do
      ChefSpec::SoloRunner.new(step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
        node.override['selinux_policy']['allow_disabled'] = false
        selinux_policy_module 'testy' do
          action :remove
        end
      end
    end
    it 'does nothing when none' do
      stub_command("/usr/sbin/semodule -l | grep -w '^testy'").and_return(false)
      expect(chef_run).not_to run_execute('semodule-remove-testy')
    end
    it 'removes when match' do
      stub_command("/usr/sbin/semodule -l | grep -w '^testy'").and_return(true)
      expect(chef_run).to run_execute('semodule-remove-testy')
    end
  end
end
