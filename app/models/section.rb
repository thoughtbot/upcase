class Section < ActiveRecord::Base
  validates_presence_of :starts_on, :ends_on

  validate :must_have_at_least_one_teacher

  belongs_to :course
  has_many :section_teachers
  has_many :teachers, :through => :section_teachers
  has_many :registrations
  has_many :students, :through => :registrations, :source => :user

  delegate :name, :description, :location, :location_name, :to => :course, :prefix => :course
  after_create :send_follow_up_emails, :send_teacher_notifications

  accepts_nested_attributes_for :section_teachers

  def self.active
    where("sections.ends_on >= ?", Date.today)
  end

  def self.by_starts_on
    order("starts_on asc")
  end

  def time_range
    "#{course.start_at.to_s(:time).strip}-#{course.stop_at.to_s(:time).strip}"
  end

  def full?
    registrations.count >= course.maximum_students
  end

  def calculate_price(coupon = nil)
    if coupon
      course.price - (course.price * (coupon.percentage * 0.01))
    else
      course.price
    end
  end

  def date_range
    if starts_on.year == ends_on.year
      if starts_on.month == ends_on.month
        if starts_on.day == ends_on.day
          "#{Date::MONTHNAMES[starts_on.month]} #{starts_on.day}, #{ends_on.year}"
        else
          "#{Date::MONTHNAMES[starts_on.month]} #{starts_on.day}-#{ends_on.day}, #{ends_on.year}"
        end
      else
        "#{Date::MONTHNAMES[starts_on.month]} #{starts_on.day}-#{Date::MONTHNAMES[ends_on.month]} #{ends_on.day}, #{ends_on.year}"
      end
    else
      "#{starts_on.to_s(:simple)}-#{ends_on.to_s(:simple)}"
    end
  end

  def to_param
    "#{id}-#{course_name.parameterize}"
  end

  protected

  def self.xml_content(document, tag_name)
    document.search(tag_name).first.try(:content)
  end

  def must_have_at_least_one_teacher
    errors.add_to_base("must specify at least one teacher") unless self.teachers.any?
  end

  def send_follow_up_emails
    self.course.follow_ups.have_not_notified.each { |follow_up| follow_up.notify(self) }
  end

  def send_teacher_notifications
    self.teachers.each do |teacher|
      UserMailer.teacher_notification(teacher, self).deliver
    end
  end
end
