class Exercise < ActiveRecord::Base
  AVERAGE_COMPLETION_TIME_IN_MINUTES = 7

  has_many :statuses, as: :completeable, dependent: :destroy
  has_one :trail, through: :step, as: :completeables
  has_one :step, dependent: :destroy, as: :completeable

  validates :name, presence: true
  validates :url, presence: true

  def trail_name
    trail.try(:name)
  end

  def self.ordered
    order(:created_at)
  end

  def accessible_without_subscription?
    false
  end
end
