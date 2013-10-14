class Step
  include Comparable

  attr_reader :name

  def initialize(step_hash)
    @name = step_hash['name']
  end

  def <=>(another_step)
    self.name <=> another_step.name
  end
end
