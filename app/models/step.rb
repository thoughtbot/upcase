class Step < ApplicationRecord
  belongs_to :trail
  belongs_to :completeable, polymorphic: true

  validates :completeable, presence: true
  validates :position, uniqueness: {scope: :trail_id}
  validates :trail, presence: true

  acts_as_list scope: :trail

  def name
    "#{completeable.class.model_name} - #{completeable.name}"
  end
end
