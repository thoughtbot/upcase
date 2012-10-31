require 'spec_helper'

describe SectionTeacher do
  # Database
  it { should have_db_index([:section_id, :teacher_id]).unique(true) }

  # Associations
  it { should belong_to(:section) }
  it { should belong_to(:teacher) }

  context '#validates_uniqueness_of' do
    it do
      section = create(:section)
      section.section_teachers.destroy_all
      create :section_teacher, section: section
      should validate_uniqueness_of(:section_id).scoped_to(:teacher_id)
    end
  end
end
