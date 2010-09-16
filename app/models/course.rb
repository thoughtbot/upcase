class Course < ActiveRecord::Base
  validates_presence_of :name, :description, :price, :start_at, :stop_at, :location

  has_many :sections
  has_many :questions
  accepts_nested_attributes_for :questions, :reject_if => :all_blank

  def questions_with_blank
    questions + [questions.new]
  end
end
