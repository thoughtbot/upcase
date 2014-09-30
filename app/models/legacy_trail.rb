class LegacyTrail < ActiveRecord::Base
  belongs_to :topic

  validates :topic_id, :slug, presence: true

  serialize :trail_map, Hash

  def name
    trail_map['name']
  end

  def total
    steps.inject(0) do |count, step|
      count += step.validations.length if step.validations
      count
    end
  end

  def steps
    trail_map['steps'].map do |step_hash|
      Step.new(step_hash)
    end
  end

  def resources_and_validations
    items = steps.map do |step|
      step.validations << step.resources
    end
    items.flatten
  end

  def reference
    trail_map['reference'] || []
  end
end
