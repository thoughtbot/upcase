class Exercise < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true

  def self.ordered
    order('position asc')
  end
end
