class Step < ActiveRecord::Base
  belongs_to :trail
  belongs_to :completeable, polymorphic: true

  validates :completeable, presence: true
  validates :position, uniqueness: { scope: :trail_id }
  validates :trail, presence: true

  acts_as_list scope: :trail

  def name
    "#{completeable.class.model_name} - #{completeable.name}"
  end

  def to_s
    "#{trail} > #{completeable.name}"
  end
end
