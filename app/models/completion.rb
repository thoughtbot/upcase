class Completion < ActiveRecord::Base
  belongs_to :user

  validates :trail_object_id, uniqueness: { scope: :user_id }
  validates :trail_name, presence: true

  def self.only_trail_object_ids
    pluck(:trail_object_id)
  end

  def title
    step = Trail.all_resources_and_validations.detect { |step| step['id'] == trail_object_id }
    step['title']
  end
end
