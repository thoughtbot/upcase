class Event < ActiveRecord::Base
  belongs_to :workshop

  validates :title, presence: true
  validates :time, presence: true
  validates :workshop_id, presence: true

  def self.ordered
    order('occurs_on_day asc')
  end
end
