class Section < ActiveRecord::Base
  belongs_to :course
  has_many :section_teachers
  has_many :teachers, :through => :section_teachers

  delegate :name, :description, :to => :course, :prefix => :course

  accepts_nested_attributes_for :section_teachers

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
end
