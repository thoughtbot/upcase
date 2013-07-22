class Completion < ActiveRecord::Base
  # Attrobutes
  attr_accessible :trail_name, :trail_object_id

  belongs_to :user

  validates :trail_object_id, uniqueness: { scope: :user_id }
  validates :trail_name, presence: true

  def self.only_trail_object_ids
    pluck(:trail_object_id)
  end
end
