class Event < ActiveRecord::Base
  belongs_to :workshop

  validates :title, presence: true
  validates :time, presence: true
  validates :workshop_id, presence: true

  def self.ordered
    order('occurs_on_day asc')
  end

  def starts_today?(start_date)
    occurs_on(start_date) == Date.today
  end

  def occurs_on(start_date)
    start_date + occurs_on_day.days
  end
end
