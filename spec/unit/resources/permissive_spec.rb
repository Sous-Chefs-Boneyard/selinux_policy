require 'spec_helper'

describe 'selinux_policy_permissive' do
  platform 'centos', '8'
  step_into :selinux_policy_permissive
  include_context 'selinux enabled'

  recipe do
    selinux_policy_permissive 'test'

    selinux_policy_permissive 'delete' do
      context 'delete_context'
      action :delete
    end
  end

  context 'when permissive is not set' do
    before do
      stub_command("/sbin/semanage permissive -l | grep -Fxq 'test'").and_return(false)
      stub_command("/sbin/semanage permissive -l | grep -Fxq 'delete_context'").and_return(false)
    end

    it do
      is_expected.to run_execute('selinux-permissive-test-add').with(
        command: "/sbin/semanage permissive -a 'test'"
      )
    end

    it { is_expected.to_not run_execute('selinux-permissive-delete_context-delete') }
  end

  context 'when permissive is set' do
    before do
      stub_command("/sbin/semanage permissive -l | grep -Fxq 'test'").and_return(true)
      stub_command("/sbin/semanage permissive -l | grep -Fxq 'delete_context'").and_return(true)
    end

    it { is_expected.to_not run_execute('selinux-permissive-test-add') }

    it do
      is_expected.to run_execute('selinux-permissive-delete_context-delete').with(
        command: "/sbin/semanage permissive -d 'delete_context'"
      )
    end
  end
end
