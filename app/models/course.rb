class Course < ActiveRecord::Base
  validates_presence_of :name, :description, :price, :start_at, :stop_at, :location, :maximum_students, :short_description

  has_many :sections
  has_many :questions
  has_many :follow_ups
  accepts_nested_attributes_for :questions, :reject_if => :all_blank
  accepts_nested_attributes_for :follow_ups, :reject_if => :all_blank

  def self.unscheduled
    where("courses.id not in (select sections.course_id from sections where sections.ends_on >= ?)", Date.today)
  end

  def questions_with_blank
    questions + [questions.new]
  end

  def follow_ups_with_blank
    follow_ups + [follow_ups.new]
  end
end
