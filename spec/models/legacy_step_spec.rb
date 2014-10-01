require "rails_helper"

describe LegacyStep do
  it 'is equal to a step with the identical name' do
    step = LegacyStep.new('name' => 'Test')
    step2 = LegacyStep.new('name' => 'Test')

    expect(step == step2).to be true
  end

  it 'is not equal to a step with a different name' do
    step = LegacyStep.new('name' => 'Test')
    step2 = LegacyStep.new('name' => 'Different')

    expect(step == step2).to be false
  end

  describe '#resources' do
    it 'returns the non-thoughtbot resources' do
      step = LegacyStep.new(step_hash)

      expect(step.resources).to eq step_hash['resources']
    end

    it 'is empty if there is only thoughtbot resources' do
      step = LegacyStep.new(thoughtbot_resource_step_hash)

      expect(step.resources).to be_empty
    end

    it 'returns an empty array when there are no resources' do
      step = LegacyStep.new({})

      expect(step.resources).to be_empty
    end
  end

  describe '#validations' do
    it 'returns the step validations array' do
      step = LegacyStep.new(step_hash)

      expect(step.validations).to eq step_hash['validations']
    end

    it 'returns an empty array when there are no validations in the step' do
      step = LegacyStep.new({})

      expect(step.validations).to be_empty
    end
  end

  describe '#thoughbot_resources' do
    it 'returns an array of the resources provided by thoughtbot' do
      step = LegacyStep.new(thoughtbot_resource_step_hash)

      expect(step.thoughtbot_resources).
        to eq thoughtbot_resource_step_hash['resources']
    end

    it 'is empty if there are no thoughtbot resources' do
      step = LegacyStep.new(step_hash)

      expect(step.thoughtbot_resources).to be_empty
    end
  end

  def step_hash
    FakeTrailMap.new.trail['steps'].first
  end

  def thoughtbot_resource_step_hash
    fake_trail_map = FakeTrailMap.new(thoughtbot_resource: true)
    fake_trail_map.trail['steps'].first
  end
end
