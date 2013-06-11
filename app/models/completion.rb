class Completion < ActiveRecord::Base
  belongs_to :user

  validates :trail_object_id, uniqueness: true
  validates :trail_name, presence: true

  def self.only_trail_object_ids
    pluck(:trail_object_id)
  end
end
