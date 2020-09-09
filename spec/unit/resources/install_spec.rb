require 'spec_helper'

describe 'selinux_policy_install' do
  step_into :selinux_policy_install

  recipe do
    selinux_policy_install 'test'
  end

  context 'on centos 6' do
    platform 'centos', '6'

    it do
      is_expected.to install_package(%w(policycoreutils-python selinux-policy setools-console make))
    end
  end

  context 'on centos 7' do
    platform 'centos', '7'

    it do
      is_expected.to install_package(%w(policycoreutils-python selinux-policy-devel setools-console make))
    end
  end

  context 'on centos 8' do
    platform 'centos', '8'

    it do
      is_expected.to install_package(%w(policycoreutils-python-utils selinux-policy-devel setools-console make))
    end
  end

  context 'on fedora' do
    platform 'fedora'

    it do
      is_expected.to install_package(%w(policycoreutils selinux-policy-devel setools-console make))
    end
  end
end
