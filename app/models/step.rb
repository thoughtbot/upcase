class Step < ActiveRecord::Base
  belongs_to :trail
  belongs_to :exercise

  validates :position, uniqueness: { scope: :trail_id }

  acts_as_list scope: :trail
end
