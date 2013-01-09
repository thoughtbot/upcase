class Audience < ActiveRecord::Base
  has_many :courses, order: "courses.position asc"

  validates :name, presence: true

  def self.by_position
    order("audiences.position asc")
  end
end
