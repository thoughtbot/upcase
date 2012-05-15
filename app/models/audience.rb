class Audience < ActiveRecord::Base
  has_many :courses, order: "courses.position asc"

  validates_presence_of :name

  def self.by_position
    order("audiences.position asc")
  end
end
