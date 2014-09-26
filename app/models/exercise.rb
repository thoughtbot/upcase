class Exercise < ActiveRecord::Base
  has_many :classifications, as: :classifiable
  has_many :statuses

  validates :title, presence: true
  validates :url, presence: true

  def self.ordered
    order(:created_at)
  end

  def status_for(user)
    statuses.where(user: user).first
  end
end
