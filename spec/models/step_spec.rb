require 'spec_helper'

describe Step do
  it 'is equal to a step with the identical name' do
    step = Step.new('name' => 'Test')
    step2 = Step.new('name' => 'Test')

    expect(step == step2).to be_true
  end

  it 'is no equal to a step with a different name' do
    step = Step.new('name' => 'Test')
    step2 = Step.new('name' => 'Different')

    expect(step == step2).to be_false
  end
end
