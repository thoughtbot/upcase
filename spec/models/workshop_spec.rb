require 'spec_helper'

describe Workshop do
  # Associations
  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:follow_ups).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:purchases).through(:sections) }
  it { should have_many(:sections) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:videos) }
  it { should have_many(:events).dependent(:destroy) }

  # Validations
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

  describe '#to_param' do
    it 'returns the id and parameterized name' do
      workshop = create(:workshop)
      workshop.to_param.should == "#{workshop.id}-#{workshop.name.parameterize}"
    end
  end

  describe '#in_person?' do
    it 'returns true if the workshop is an in-person workshop' do
      workshop = create(:workshop, online: false)

      workshop.should be_in_person
    end

    it 'returns false if the workshop is not an in-person workshop' do
      workshop = create(:workshop, online: true)

      workshop.should_not be_in_person
    end
  end

  describe '#has_online_workshop?' do
    it 'returns true if there is an online workshop with the same name' do
      offline_workshop = create(:workshop, online: false)
      online_workshop = create(:workshop, online: true,
        name: offline_workshop.name)

      offline_workshop.should have_online_workshop
    end

    it 'returns false if it does not have an online workshop' do
      workshop = create(:workshop, online: false)

      workshop.should_not have_online_workshop
    end

    it 'returns falsy when there the workshop is online' do
      online_workshop = create(:workshop, online: true)

      online_workshop.should_not have_online_workshop
    end
  end

  describe '#online_workshop' do
    it 'returns the online workshop with the same name' do
      offline_workshop = create(:workshop, online: false)
      online_workshop = create(:workshop, online: true,
        name: offline_workshop.name)

      offline_workshop.online_workshop.should == online_workshop
    end

    it 'returns nil if it does not have an online workshop' do
      offline_workshop = create(:workshop, online: false)

      offline_workshop.online_workshop.should_not be
    end

    it 'returns falsy when the workshop is online' do
      online_workshop = create(:workshop, online: true)

      online_workshop.online_workshop.should_not be
    end
  end

  describe '#in_person_workshop' do
    it 'returns the in-person workshop when it exists' do
      online_workshop = create(:workshop, online: true)
      in_person_workshop = create(:workshop, online: false,
        name: online_workshop.name)

      online_workshop.in_person_workshop.should == in_person_workshop
    end

    it 'returns falsy when there is no in-person workshop' do
      online_workshop = create(:workshop, online: true)

      online_workshop.in_person_workshop.should_not be
    end

    it 'returns falsy when the workshop is in-person' do
      in_person_workshop = create(:workshop, online: false)

      in_person_workshop.in_person_workshop.should_not be
    end
  end

  describe '#has_in_person_workshop?' do
    it 'returns true when there is an in-person workshop' do
      online_workshop = create(:workshop, online: true)
      in_person_workshop = create(:workshop, online: false,
        name: online_workshop.name)

      online_workshop.should have_in_person_workshop
    end

    it 'returns false when there is not an in-person workshop' do
      online_workshop = create(:workshop, online: true)

      online_workshop.should_not have_in_person_workshop
    end

    it 'returns falsy when the workshop is in-person' do
      in_person_workshop = create(:workshop, online: false)

      in_person_workshop.should_not have_in_person_workshop
    end
  end

  context 'purchase_for' do
    it 'returns the purchase when a user has purchased a section of the workshop' do
      user = create(:user)
      purchase = create(:section_purchase, user: user)
      workshop = purchase.purchaseable.workshop

      expect(workshop.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased a section fo the workshop' do
      user = create(:user)
      purchase = create(:section_purchase)
      workshop = purchase.purchaseable.workshop

      expect(workshop.purchase_for(user)).to be_nil
    end
  end
end
