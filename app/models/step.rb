class Step
  include Comparable

  attr_reader :name, :validations

  def initialize(step_hash)
    @name = step_hash['name']
    @resources = step_hash['resources'] || []
    @validations = step_hash['validations'] || []
  end

  def <=>(another_step)
    self.name <=> another_step.name
  end

  def resources
    @resources.reject do |resource|
      thoughtbot_resource?(resource)
    end
  end

  def resources_present?
    resources.present?
  end

  def thoughtbot_resources
    @resources.select do |resource|
      thoughtbot_resource?(resource)
    end
  end

  def thoughtbot_resources_present?
    thoughtbot_resources.present?
  end

  def validations_present?
    validations.count >= 1
  end

  private

  def thoughtbot_resource?(resource)
    if resource['uri']
      Addressable::URI.parse(resource['uri']).host == 'upcase.com'
    end
  end

end
