require 'spec_helper'

describe Course do
  # Associations
  it { should have_many(:announcements).dependent(:destroy) }
  it { should belong_to(:audience) }
  it { should have_many(:classifications) }
  it { should have_many(:follow_ups) }
  it { should have_many(:questions) }
  it { should have_many(:purchases).through(:sections) }
  it { should have_many(:sections) }
  it { should have_many(:topics).through(:classifications) }

  # Validations
  it { should validate_presence_of(:audience_id) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:maximum_students) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:company_price) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:stop_at) }

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      course = create(:course)
      course.announcement
      Announcement.should have_received(:current)
    end
  end

  describe '.in_person' do
    it 'returns in-person courses' do
      course = create(:course, online: false)

      Course.in_person.should == [course]
    end

    it 'does not return online courses' do
      create(:course, online: true)

      Course.in_person.should be_empty
    end
  end

  describe '.online' do
    it 'returns online courses' do
      course = create(:course, online: true)

      Course.online.should == [course]
    end

    it 'does not return in-person courses' do
      create(:course, online: false)

      Course.online.should be_empty
    end
  end

  describe '.promoted' do
    it 'returns the promoted course in the location' do
      course = create(:course, promo_location: 'left')
      Course.promoted('left').should == course
    end
  end

  describe '#to_param' do
    it 'returns the id and parameterized name' do
      course = create(:course)
      course.to_param.should == "#{course.id}-#{course.name.parameterize}"
    end
  end
end
