require 'spec_helper'

describe Workshop do
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
      workshop = create(:workshop)
      workshop.announcement
      Announcement.should have_received(:current)
    end
  end

  describe '.in_person' do
    it 'returns in-person workshops' do
      workshop = create(:workshop, online: false)

      Workshop.in_person.should == [workshop]
    end

    it 'does not return online workshops' do
      create(:workshop, online: true)

      Workshop.in_person.should be_empty
    end
  end

  describe '.online' do
    it 'returns online workshops' do
      workshop = create(:workshop, online: true)

      Workshop.online.should == [workshop]
    end

    it 'does not return in-person workshops' do
      create(:workshop, online: false)

      Workshop.online.should be_empty
    end
  end

  describe '.promoted' do
    it 'returns the promoted workshop in the location' do
      workshop = create(:workshop, promo_location: 'left')
      Workshop.promoted('left').should == workshop
    end
  end

  describe '#to_param' do
    it 'returns the id and parameterized name' do
      workshop = create(:workshop)
      workshop.to_param.should == "#{workshop.id}-#{workshop.name.parameterize}"
    end
  end
end
