class Step
  include Comparable

  attr_reader :name, :resources, :validations

  def initialize(step_hash)
    @name = step_hash['name']
    @resources = step_hash['resources']
    @validations = step_hash['validations']
  end

  def <=>(another_step)
    self.name <=> another_step.name
  end
end
