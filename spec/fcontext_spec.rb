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


describe 'selinux_policy fcontext' do

  let :chef_run do
    ChefSpec::SoloRunner.new(step_into: ['selinux_policy_fcontext']).converge_dsl('selinux_policy') do
      node.override['selinux_policy']['allow_disabled'] = false
      selinux_policy_fcontext '/tmp/test' do
        secontext 'http_dir_t'
      end
    end
  end

  describe 'AddOrModify' do
    it 'creates when none' do
      stub_command("/usr/sbin/semanage fcontext -l | grep -P '/tmp/test .* system_u:object_r:http_dir_t:s0'>/dev/null").and_return(false)
      expect(chef_run).to run_execute('selinux-fcontext-http_dir_t-addormodify')
    end
    it 'modifies when exists and mismatch' do
    end
    it 'does nothing when match' do
    end
  end

  describe 'Add' do
    it 'creates when none' do
    end
    it 'does nothing when exists' do
    end
  end

  describe 'Modify' do
    it 'does nothing when none' do
    end
    it 'modifies when exists and mismatch' do
    end
    it 'does nothing when match' do
    end
  end

  describe 'Delete' do
    it 'does nothing when none' do
    end
    it 'removes when match' do
    end
  end
end
