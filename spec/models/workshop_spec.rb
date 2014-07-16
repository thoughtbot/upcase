require 'spec_helper'

describe Workshop do
  # Associations
  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:downloads) }
  it { should have_many(:licenses).dependent(:restrict_with_exception) }
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
  it { should validate_presence_of(:slug) }

  context "uniqueness" do
    before do
      create :workshop
    end

    it { should validate_uniqueness_of(:slug) }
  end

  describe 'self.promoted' do
    it 'returns promoted workshops' do
      promoted_workshops = create_list(:workshop, 2, promoted: true)
      create(:workshop, promoted: false)

      expect(Workshop.promoted).to eq(promoted_workshops)
    end
  end

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      workshop = create(:workshop)
      workshop.announcement
      expect(Announcement).to have_received(:current)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      workshop = create(:workshop)
      expect(workshop.to_param).to eq workshop.slug
    end
  end

  context "license_for" do
    it "returns the license when a user has licensed a section of the workshop" do
      user = create(:user)
      workshop = create(:workshop)
      license = create(:license, licenseable: workshop, user: user)

      expect(workshop.license_for(user)).to eq license
    end

    it 'returns nil when a user has not licensed a section fo the workshop' do
      user = create(:user)
      workshop = create(:workshop)
      create(:license, licenseable: workshop)

      expect(workshop.license_for(user)).to be_nil
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

  describe "#fulfilled_with_github" do
    it "is true when workshop has a github team" do
      workshop = build(:workshop, :github)

      expect(workshop).to be_fulfilled_with_github
    end

    it "is false when workshop has no github team" do
      workshop = build(:workshop, github_team: nil)

      expect(workshop).to_not be_fulfilled_with_github
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
      license = build_stubbed(:license)
      user = build_stubbed(:user)
      fulfillment = stub('fulfillment', :fulfill)
      workshop = build_stubbed(:workshop, github_team: 'example')
      GithubFulfillment.stubs(:new).with(license).returns(fulfillment)

      workshop.fulfill(license, user)

      expect(fulfillment).to have_received(:fulfill)
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
