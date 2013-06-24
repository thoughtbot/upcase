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

  # Validations
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:company_price) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:stop_at) }
  it { should validate_presence_of(:sku) }

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

  describe '#alternates' do
    it 'returns the active online workshop with the same name' do
      offline_workshop = create(:workshop, online: false)
      wrong_online_workshop = create(:workshop, online: true)
      online_workshop = create(
        :workshop,
        online: true,
        name: offline_workshop.name,
        active: true
      )

      result = offline_workshop.alternates

      expect(result).to eq [
        build(:alternate, key: 'online_workshop', offering: online_workshop)
      ]
    end

    it 'returns the in_person workshop when it exists' do
      online_workshop = create(:workshop, online: true)
      in_person_workshop = create(
        :workshop,
        online: false,
        name: online_workshop.name,
        active: true
      )

      result = online_workshop.alternates

      expect(result).to eq [
        build(:alternate, key: 'in_person_workshop', offering: in_person_workshop)
      ]
    end

    it 'returns nothing for an in_person workshop without an online workshop' do
      in_person_workshop = create(:workshop, online: false)

      result = in_person_workshop.alternates

      expect(result).to eq []
    end

    it 'returns nothing for an online workshop without an offline workshop' do
      online_workshop = create(:workshop, online: true)

      result = online_workshop.alternates

      expect(result).to eq []
    end

    it 'returns nothing when the alternate is inactive' do
      online_workshop = create(:workshop, online: true)
      in_person_workshop = create(
        :workshop,
        online: false,
        name: online_workshop.name,
        active: false
      )

      result = online_workshop.alternates

      expect(result).to eq []
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

  describe 'title' do
    it 'describes the workshop name' do
      workshop = build_stubbed(:workshop, name: 'Billy')

      result = workshop.title

      expect(result).to eq 'Billy: a workshop from thoughtbot'
    end
  end

  describe "#meta_keywords" do
    it { should delegate(:meta_keywords).to(:topics) }
  end

  describe 'offering_type' do
    it 'returns in_person_workshop for an in-person workshop' do
      workshop = Workshop.new(online: false)

      result = workshop.offering_type

      expect(result).to eq 'in_person_workshop'
    end

    it 'returns online_workshop for an online workshop' do
      workshop = Workshop.new(online: true)

      result = workshop.offering_type

      expect(result).to eq 'online_workshop'
    end
  end

  describe '#tagline' do
    it 'returns the short description' do
      workshop = build_stubbed(:workshop)

      result = workshop.tagline

      expect(result).to eq(workshop.short_description)
    end
  end

  describe '#fulfilled_with_github' do
    it 'is true when product has a github team' do
      product = build(:github_book_product)
      purchase = build(:purchase, purchaseable: product)

      purchase.should be_fulfilled_with_github
    end

    it 'is false when product has no github team' do
      product = build(:book_product, github_team: nil)
      purchase = build(:purchase, purchaseable: product)

      purchase.should_not be_fulfilled_with_github
    end
  end

  describe '#starts_immediately?' do
    it 'does not start immediately when the active section has an end date' do
      section = create(
        :section,
        starts_on: Time.zone.today,
        ends_on: 1.day.from_now
      )
      workshop = section.workshop

      expect(workshop.starts_immediately?).to be false
    end

    it 'starts immediately when the active section does not have an end date' do
      section = create(
        :section,
        starts_on: Time.zone.today,
        ends_on: nil
      )
      workshop = section.workshop

      expect(workshop.starts_immediately?).to be_true
    end

    it 'does not start immediately when there is no active section' do
      workshop = create(:workshop)

      expect(workshop.starts_immediately?).to be_false
    end
  end

  describe '#thumbnail_path' do
    it 'returns the path to a thumbnail image representing the workshop' do
      workshop = build_stubbed(:workshop, name: 'Intro to Ruby On Rails')

      expect(workshop.thumbnail_path).to eq "workshop_thumbs/#{workshop.name.parameterize}.png"
    end
  end
end
