require 'spec_helper'

describe 'selinux_policy::install' do
  platform 'centos'

  describe 'installs packages' do
    it { is_expected.to install_selinux_policy_install('install') }
  end
end
