require 'spec_helper'
describe 'puppet_ent_agent' do
  context 'with defaults for all parameters' do
    it { should contain_class('puppet_ent_agent') }
  end
end
