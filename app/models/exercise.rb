class Exercise < ActiveRecord::Base
  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :trails, through: :steps, as: :completeables
  has_many :steps, dependent: :destroy, as: :completeable

  validates :name, presence: true
  validates :url, presence: true

  def self.ordered
    order(:created_at)
  end

  def self.public
    where(public: true)
  end

  def update_trails_state_for(user)
    trails.each { |trail| trail.update_state_for(user) }
  end
end
