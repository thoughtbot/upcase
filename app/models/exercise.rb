class Exercise < ActiveRecord::Base
  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :steps, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true

  def self.ordered
    order(:created_at)
  end

  def self.public
    where(public: true)
  end
end
