require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/helpers'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end

shared_context 'selinux enabled' do
  before do
    allow_any_instance_of(SELinuxPolicy::Cookbook::Helpers).to receive(:use_selinux).and_return(true)
  end
end
