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
    it 'returns the step non-thoughtbot resources' do
      step_hash = FakeTrailMap.new.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.resources).to eq step_hash['resources']
    end

    it 'is empty if the step is only thoughtbot resources' do
      fake_trail_map = FakeTrailMap.new
      fake_trail_map.resource_uri = 'http://learn.thoughtbot.com/workshops/1'
      step_hash = fake_trail_map.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.resources).to be_empty
    end
  end

  describe '#validations' do
    it 'returns the step validations array' do
      step_hash = FakeTrailMap.new.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.validations).to eq step_hash['validations']
    end
  end

  describe '#thoughbot_resources' do
    it 'returns an array of the resources provided by thoughtbot' do
      fake_trail_map = FakeTrailMap.new
      fake_trail_map.resource_uri = 'http://learn.thoughtbot.com/workshops/1'
      step_hash = fake_trail_map.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.thoughtbot_resources).to eq step_hash['resources']
    end

    it 'is empty if there are no thoughtbot resources' do
      fake_trail_map = FakeTrailMap.new
      step_hash = fake_trail_map.trail['steps'].first
      step = Step.new(step_hash)

      expect(step.thoughtbot_resources).to be_empty
    end
  end
end
