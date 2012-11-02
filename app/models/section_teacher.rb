class SectionTeacher < ActiveRecord::Base
  # Associations
  belongs_to :section
  belongs_to :teacher

  # Validations
  validates :section_id, uniqueness: { scope: :teacher_id }
end
