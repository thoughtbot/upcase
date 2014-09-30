class Completion < ActiveRecord::Base
  belongs_to :user

  validates :trail_object_id, uniqueness: { scope: :user_id }
  validates :trail_name, presence: true
  validates :slug, presence: true

  def self.only_trail_object_ids
    pluck(:trail_object_id)
  end

  def title
    if step
      step['title']
    end
  end

  def trail_name=(name)
    write_attribute(:trail_name, name)
    set_slug
  end

  private

  def resources_and_validations
    @resources_and_validations ||= LegacyTrail.find_by_slug(slug).resources_and_validations
  end

  def step
    @step ||= resources_and_validations.detect { |step| step['id'] == trail_object_id }
  end

  def set_slug
    LegacyTrail.all.each do |trail|
      if trail.trail_map['name'] == trail_name
        write_attribute(:slug, trail.slug)
      end
    end
  end
end
