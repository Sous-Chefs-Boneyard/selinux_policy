require 'spec_helper'

describe 'selinux_policy_fcontext' do
  platform 'centos', '8'
  step_into :selinux_policy_fcontext
  include_context 'selinux enabled'

  recipe do
    selinux_policy_fcontext 'addormodify_test' do
      file_spec '/file/spec.path'
      secontext 'aom_context'
    end

    selinux_policy_fcontext 'add_test' do
      file_spec '/file/spec.path'
      secontext 'add_context'
      action :add
    end

    selinux_policy_fcontext 'modify_test' do
      file_spec '/file/spec.path'
      secontext 'modify_context'
      action :modify
    end

    selinux_policy_fcontext 'delete_test' do
      file_spec '/file/spec.path'
      secontext 'delete_context'
      action :delete
    end

    selinux_policy_fcontext 'file_test' do
      file_spec '/file/spec.path'
      file_type 'f'
      secontext 'file_context'
    end

    selinux_policy_fcontext 'link_test' do
      file_spec '/file/spec.path'
      file_type 'l'
      secontext 'link_context'
    end
  end

  before do
    stub_command("/sbin/semanage fcontext -l | grep -qP '^/file/spec\\.path\\s+all\\ files\\s+'").and_return(has_context)
    %w(aom add modify delete).each do |c|
      stub_command("/sbin/semanage fcontext -l | grep -qP '^/file/spec\\.path\\s+all\\ files\\s+system_u:object_r:#{c}_context:s0\\s*$'").and_return(has_correct_context)
    end

    stub_command("/sbin/semanage fcontext -l | grep -qP '^/file/spec\\.path\\s+regular\\ file\\s+'").and_return(has_context)
    stub_command("/sbin/semanage fcontext -l | grep -qP '^/file/spec\\.path\\s+symbolic\\ link\\s+'").and_return(has_context)
    stub_command("/sbin/semanage fcontext -l | grep -qP '^/file/spec\\.path\\s+regular\\ file\\s+system_u:object_r:file_context:s0\\s*$'").and_return(has_correct_context)
    stub_command("/sbin/semanage fcontext -l | grep -qP '^/file/spec\\.path\\s+symbolic\\ link\\s+system_u:object_r:link_context:s0\\s*$'").and_return(has_correct_context)
  end

  context 'when context is not set' do
    let(:has_context) { false }
    let(:has_correct_context) { false }

    it do
      is_expected.to run_execute('selinux-fcontext-aom_context-add').with(
        command: "/sbin/semanage fcontext -a -f a -t aom_context '/file/spec.path'"
      )
    end
    it { is_expected.to_not run_execute('selinux-fcontext-aom_context-modify') }

    it do
      is_expected.to run_execute('selinux-fcontext-add_context-add').with(
        command: "/sbin/semanage fcontext -a -f a -t add_context '/file/spec.path'"
      )
    end

    it { is_expected.to_not run_execute('selinux-fcontext-modify_context-modify') }

    it { is_expected.to_not run_execute('selinux-fcontext-delete_context-delete') }

    it do
      is_expected.to run_execute('selinux-fcontext-file_context-add').with(
        command: "/sbin/semanage fcontext -a -f f -t file_context '/file/spec.path'"
      )
    end
    it { is_expected.to_not run_execute('selinux-fcontext-file_context-modify') }

    it do
      is_expected.to run_execute('selinux-fcontext-link_context-add').with(
        command: "/sbin/semanage fcontext -a -f l -t link_context '/file/spec.path'"
      )
    end
    it { is_expected.to_not run_execute('selinux-fcontext-link_context-modify') }
  end

  context 'when context is set to other value' do
    let(:has_context) { true }
    let(:has_correct_context) { false }

    it { is_expected.to_not run_execute('selinux-fcontext-aom_context-add') }
    it do
      is_expected.to run_execute('selinux-fcontext-aom_context-modify').with(
        command: "/sbin/semanage fcontext -m -f a -t aom_context '/file/spec.path'"
      )
    end

    it { is_expected.to_not run_execute('selinux-fcontext-add_context-add') }

    it do
      is_expected.to run_execute('selinux-fcontext-modify_context-modify').with(
        command: "/sbin/semanage fcontext -m -f a -t modify_context '/file/spec.path'"
      )
    end

    it { is_expected.to_not run_execute('selinux-fcontext-delete_context-delete') }

    it { is_expected.to_not run_execute('selinux-fcontext-file_context-add') }
    it do
      is_expected.to run_execute('selinux-fcontext-file_context-modify').with(
        command: "/sbin/semanage fcontext -m -f f -t file_context '/file/spec.path'"
      )
    end

    it { is_expected.to_not run_execute('selinux-fcontext-link_context-add') }
    it do
      is_expected.to run_execute('selinux-fcontext-link_context-modify').with(
        command: "/sbin/semanage fcontext -m -f l -t link_context '/file/spec.path'"
      )
    end
  end

  context 'when context is set to correct value' do
    let(:has_context) { true }
    let(:has_correct_context) { true }

    it { is_expected.to_not run_execute('selinux-fcontext-aom_context-add') }
    it { is_expected.to_not run_execute('selinux-fcontext-aom_context-modify') }

    it { is_expected.to_not run_execute('selinux-fcontext-add_context-add') }

    it { is_expected.to_not run_execute('selinux-fcontext-modify_context-modify') }

    it do
      is_expected.to run_execute('selinux-fcontext-delete_context-delete').with(
        command: "/sbin/semanage fcontext -f a -d '/file/spec.path'"
      )
    end

    it { is_expected.to_not run_execute('selinux-fcontext-file_context-add') }
    it { is_expected.to_not run_execute('selinux-fcontext-file_context-modify') }

    it { is_expected.to_not run_execute('selinux-fcontext-link_context-add') }
    it { is_expected.to_not run_execute('selinux-fcontext-link_context-modify') }
  end
end
