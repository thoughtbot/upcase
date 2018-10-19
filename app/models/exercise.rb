class Exercise < ApplicationRecord
  AVERAGE_COMPLETION_TIME_IN_MINUTES = 60

  has_many :statuses, as: :completeable, dependent: :destroy
  has_one :step, dependent: :destroy, as: :completeable
  has_one :trail, through: :step, as: :completeables

  validates :name, presence: true
  validates :url, presence: true

  def trail_name
    trail.try(:name)
  end

  def self.ordered
    order(:created_at)
  end
end
