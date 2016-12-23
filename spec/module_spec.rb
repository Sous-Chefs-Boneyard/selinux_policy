require 'spec_helper'

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

describe 'selinux_policy module' do
  def chef_run_module(*actions)
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
      node.override['selinux_policy']['allow_disabled'] = false
      selinux_policy_module 'testy' do
        action actions
        content <<-eos
          policy_module(testy, 1.0.0)
          type testy_t;
          eos
      end
    end
  end
  describe 'fetch' do
    describe 'disallows both source_directory and content' do
      let :chef_run do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
          node.override['selinux_policy']['allow_disabled'] = false
          selinux_policy_module 'testy' do
            action :fetch
            content <<-eos
              policy_module(testy, 1.0.0)
              type testy_t;
              eos
            directory_source 'lolzaur'
          end
        end
      end
      it 'works' do
        expect { chef_run }.to raise_error(Exception)
      end
    end
    describe 'source_directory' do
      let :chef_run do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
          node.override['selinux_policy']['allow_disabled'] = false
          selinux_policy_module 'testy' do
            action :fetch
            directory_source 'lolzaur'
          end
        end
      end
      it 'works' do
        expect { chef_run }.not_to raise_error(Exception)
      end
    end
    describe 'content' do
      let :chef_run do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
          node.override['selinux_policy']['allow_disabled'] = false
          selinux_policy_module 'testy' do
            action :fetch
            content <<-eos
              policy_module(testy, 1.0.0)
              type testy_t;
              eos
          end
        end
      end
      it 'works' do
        expect { chef_run }.not_to raise_error(Exception)
      end
    end
  end
  describe 'compile' do
    let(:chef_run) { chef_run_module(:compile) }
    it 'acts when needed' do
      stub_command('/usr/bin/make -f /usr/share/selinux/devel/Makefile testy.pp -q').and_return(false)
      expect(chef_run).to run_execute('semodule-compile-testy')
    end
    it 'does nothing when not needed' do
      stub_command('/usr/bin/make -f /usr/share/selinux/devel/Makefile testy.pp -q').and_return(true)
      expect(chef_run).not_to run_execute('semodule-compile-testy')
    end
  end
  describe 'install' do
    let(:chef_run) { chef_run_module(:install) }
    it 'acts when needed' do
      stub_command("false || ! (/usr/sbin/semodule -l | grep -w '^testy') ").and_return(true)
      expect(chef_run).to run_execute('semodule-install-testy')
    end
    it 'does nothing when not needed' do
      stub_command("false || ! (/usr/sbin/semodule -l | grep -w '^testy') ").and_return(false)
      expect(chef_run).not_to run_execute('semodule-install-testy')
    end
  end
  describe 'Remove' do
    let :chef_run do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['selinux_policy_module']).converge_dsl('selinux_policy') do
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
