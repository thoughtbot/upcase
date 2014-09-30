class Exercise < ActiveRecord::Base
  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :statuses, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true

  def self.ordered
    order(:created_at)
  end

  def status_for(user)
    statuses.where(user: user).most_recent || NotStarted.new
  end
end
