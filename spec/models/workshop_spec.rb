require 'spec_helper'

describe Workshop do
  # Associations
  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:downloads) }
  it { should have_many(:purchases).dependent(:restrict_with_exception) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:teachers).dependent(:destroy) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:users).through(:teachers) }
  it { should have_many(:videos) }

  # Validations
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:length_in_days) }

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      workshop = create(:workshop)
      workshop.announcement
      Announcement.should have_received(:current)
    end
  end

  describe '#to_param' do
    it 'returns the id and parameterized name' do
      workshop = create(:workshop)
      workshop.to_param.should == "#{workshop.id}-#{workshop.name.parameterize}"
    end
  end

  context 'purchase_for' do
    it 'returns the purchase when a user has purchased a section of the workshop' do
      user = create(:user)
      purchase = create_subscriber_purchase(:workshop, user)
      workshop = purchase.purchaseable

      expect(workshop.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased a section fo the workshop' do
      user = create(:user)
      purchase = create_subscriber_purchase(:workshop)
      workshop = purchase.purchaseable

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
    it 'returns workshop' do
      workshop = Workshop.new

      result = workshop.offering_type

      expect(result).to eq 'workshop'
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
      product = build(:book, :github)
      purchase = build(:purchase, purchaseable: product)

      purchase.should be_fulfilled_with_github
    end

    it 'is false when product has no github team' do
      product = build(:book, github_team: nil)
      purchase = build(:purchase, purchaseable: product)

      purchase.should_not be_fulfilled_with_github
    end
  end

  describe '#thumbnail_path' do
    it 'returns the path to a thumbnail image representing the workshop' do
      workshop = build_stubbed(:workshop, name: 'Intro to Ruby On Rails')

      expect(workshop.thumbnail_path).to eq "workshop_thumbs/#{workshop.name.parameterize}.png"
    end
  end

  describe '#subscription?' do
    it 'returns false' do
      expect(Workshop.new).not_to be_subscription
    end
  end

  describe '#fulfill' do
    it 'fulfills using GitHub with a GitHub team' do
      purchase = build_stubbed(:purchase)
      user = build_stubbed(:user)
      fulfillment = stub('fulfillment', :fulfill)
      workshop = build_stubbed(:workshop, github_team: 'example')
      GithubFulfillment.stubs(:new).with(purchase).returns(fulfillment)

      workshop.fulfill(purchase, user)

      fulfillment.should have_received(:fulfill)
    end
  end

  describe 'starts_on' do
    it 'returns the given date' do
      workshop = build(:workshop)
      yesterday = 1.day.ago

      expect(workshop.starts_on(yesterday)).to eq yesterday
    end

    it 'returns the today when given no date' do
      workshop = build(:workshop)

      expect(workshop.starts_on).to eq Time.zone.today
    end
  end

  describe 'ends_on' do
    it 'returns the date equal to the given date plus the length of the workshop' do
      workshop = build(:workshop, length_in_days: 28)
      yesterday = 1.day.ago.to_date

      expect(workshop.ends_on(yesterday)).to eq (yesterday + 28.days)
    end

    it 'returns the date equal to today plus the length of the workshop when given no date' do
      ends_on = 14.days.from_now.to_date
      workshop = build(:workshop, length_in_days: 14)

      expect(workshop.ends_on).to eq ends_on
    end
  end

  describe '#collection?' do
    it 'should be true' do
      expect(Workshop.new).to be_collection
    end
  end

  describe '#to_aside_partial' do
    it 'returns the path to the aside partial' do
      expect(Workshop.new.to_aside_partial).to eq 'workshops/aside'
    end
  end
end
