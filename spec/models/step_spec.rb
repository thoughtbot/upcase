require 'spec_helper'

describe Step do
  it 'is equal to a step with the identical name' do
    step = Step.new('name' => 'Test')
    step2 = Step.new('name' => 'Test')

    expect(step == step2).to be_true
  end

  it 'is not equal to a step with a different name' do
    step = Step.new('name' => 'Test')
    step2 = Step.new('name' => 'Different')

    expect(step == step2).to be_false
  end

  describe '#resources' do
    it 'returns the step resources array' do
      step_hash = FakeTrailMap.new.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.resources).to eq step_hash['resources']
    end
  end

  describe '#validations' do
    it 'returns the step validations array' do
      step_hash = FakeTrailMap.new.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.validations).to eq step_hash['validations']
    end
  end

end
