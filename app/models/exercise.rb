class Exercise < ActiveRecord::Base
  has_many :classifications, as: :classifiable

  validates :title, presence: true
  validates :url, presence: true

  def self.ordered
    order(:created_at)
  end
end
