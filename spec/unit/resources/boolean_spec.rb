require 'spec_helper'

describe 'selinux_policy_boolean' do
  platform 'centos', '8'
  step_into :selinux_policy_boolean
  include_context 'selinux enabled'

  recipe do
    selinux_policy_boolean 'test' do
      value true
    end

    selinux_policy_boolean 'nopersist' do
      value false
      action :set
    end

    selinux_policy_boolean 'force' do
      value true
      force true
    end
  end

  context 'when not set' do
    before do
      stub_command("/sbin/getsebool test | grep -q 'on$'").and_return(false)
      stub_command("/sbin/getsebool nopersist | grep -q 'off$'").and_return(false)
      stub_command("/sbin/getsebool force | grep -q 'on$'").and_return(false)
    end

    it do
      is_expected.to run_execute('selinux-setbool-test-on').with(
        command: '/sbin/setsebool -P test on'
      )
    end

    it do
      is_expected.to run_execute('selinux-setbool-nopersist-off').with(
        command: '/sbin/setsebool  nopersist off'
      )
    end

    it do
      is_expected.to run_execute('selinux-setbool-force-on').with(
        command: '/sbin/setsebool -P force on'
      )
    end
  end

  context 'when set' do
    before do
      stub_command("/sbin/getsebool test | grep -q 'on$'").and_return(true)
      stub_command("/sbin/getsebool nopersist | grep -q 'off$'").and_return(true)
      stub_command("/sbin/getsebool force | grep -q 'on$'").and_return(true)
    end

    it do
      is_expected.to_not run_execute('selinux-setbool-test-on').with(
        command: '/sbin/setsebool -P test on'
      )
    end

    it do
      is_expected.to_not run_execute('selinux-setbool-nopersist-off').with(
        command: '/sbin/setsebool  nopersist off'
      )
    end

    it do
      is_expected.to run_execute('selinux-setbool-force-on').with(
        command: '/sbin/setsebool -P force on'
      )
    end
  end
end
