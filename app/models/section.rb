class Section < ActiveRecord::Base
  validates_presence_of :starts_on, :ends_on, :chargify_id

  validate :must_have_at_least_one_teacher

  belongs_to :course
  has_many :section_teachers
  has_many :teachers, :through => :section_teachers
  has_many :registrations
  has_many :students, :through => :registrations, :source => :user

  delegate :name, :description, :location, :to => :course, :prefix => :course

  accepts_nested_attributes_for :section_teachers

  def time_range
    "#{course.start_at.to_s(:time)}-#{course.stop_at.to_s(:time)}"
  end

  def registration_link
    "http://thoughtbot-workshops.chargify.com/h/#{chargify_id}/subscriptions/new"
  end

  def calculate_price
    open("https://thoughtbot-workshops.chargify.com/products/#{chargify_id}.xml") do |f|
      doc = Nokogiri::XML(f.read)
      (self.class.xml_content(doc, "price_in_cents").to_i / 100.0).to_i
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

  protected

  def self.xml_content(document, tag_name)
    document.search(tag_name).first.try(:content)
  end

  def must_have_at_least_one_teacher
    errors.add_to_base("must specify at least one teacher") unless self.section_teachers.any?
  end
end
