class SectionTeacher < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :section
end
