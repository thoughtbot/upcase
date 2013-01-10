class Audience < ActiveRecord::Base
  has_many :workshops, order: "workshops.position asc"

  validates :name, presence: true

  def self.by_position
    order("audiences.position asc")
  end
end
