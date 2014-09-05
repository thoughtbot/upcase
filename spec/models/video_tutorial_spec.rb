require "rails_helper"

describe VideoTutorial do
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
      create :video_tutorial
    end

    it { should validate_uniqueness_of(:slug) }
  end

  describe 'self.promoted' do
    it 'returns promoted video_tutorials' do
      promoted_video_tutorials = create_list(:video_tutorial, 2, promoted: true)
      create(:video_tutorial, promoted: false)

      expect(VideoTutorial.promoted).to eq(promoted_video_tutorials)
    end
  end

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      video_tutorial = create(:video_tutorial)
      video_tutorial.announcement
      expect(Announcement).to have_received(:current)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      video_tutorial = create(:video_tutorial)
      expect(video_tutorial.to_param).to eq video_tutorial.slug
    end
  end

  context "license_for" do
    it "returns the license when a user has licensed a section of the video_tutorial" do
      user = create(:user)
      video_tutorial = create(:video_tutorial)
      license = create(:license, licenseable: video_tutorial, user: user)

      expect(video_tutorial.license_for(user)).to eq license
    end

    it 'returns nil when a user has not licensed a section fo the video_tutorial' do
      user = create(:user)
      video_tutorial = create(:video_tutorial)
      create(:license, licenseable: video_tutorial)

      expect(video_tutorial.license_for(user)).to be_nil
    end
  end

  describe 'title' do
    it 'describes the video_tutorial name' do
      video_tutorial = build_stubbed(:video_tutorial, name: 'Billy')

      result = video_tutorial.title

      expect(result).to eq 'Billy: a video_tutorial from thoughtbot'
    end
  end

  describe "#meta_keywords" do
    it { should delegate(:meta_keywords).to(:topics) }
  end

  describe 'offering_type' do
    it 'returns video_tutorial' do
      video_tutorial = VideoTutorial.new

      result = video_tutorial.offering_type

      expect(result).to eq 'video_tutorial'
    end
  end

  describe '#tagline' do
    it 'returns the short description' do
      video_tutorial = build_stubbed(:video_tutorial)

      result = video_tutorial.tagline

      expect(result).to eq(video_tutorial.short_description)
    end
  end

  describe "#fulfilled_with_github" do
    it "is true when video_tutorial has a github team" do
      video_tutorial = build(:video_tutorial, :github)

      expect(video_tutorial).to be_fulfilled_with_github
    end

    it "is false when video_tutorial has no github team" do
      video_tutorial = build(:video_tutorial, github_team: nil)

      expect(video_tutorial).to_not be_fulfilled_with_github
    end
  end

  describe '#thumbnail_path' do
    it 'returns the path to a thumbnail image representing the video_tutorial' do
      video_tutorial = build_stubbed(:video_tutorial, name: 'Intro to Ruby On Rails')

      expect(video_tutorial.thumbnail_path).to eq "video_tutorial_thumbs/#{video_tutorial.name.parameterize}.png"
    end
  end

  describe '#subscription?' do
    it 'returns false' do
      expect(VideoTutorial.new).not_to be_subscription
    end
  end

  describe '#fulfill' do
    it 'fulfills using GitHub with a GitHub team' do
      license = build_stubbed(:license)
      user = build_stubbed(:user)
      fulfillment = stub('fulfillment', :fulfill)
      video_tutorial = build_stubbed(:video_tutorial, github_team: 'example')
      GithubFulfillment.stubs(:new).with(license).returns(fulfillment)

      video_tutorial.fulfill(license, user)

      expect(fulfillment).to have_received(:fulfill)
    end
  end

  describe 'starts_on' do
    it 'returns the given date' do
      video_tutorial = build(:video_tutorial)
      yesterday = 1.day.ago

      expect(video_tutorial.starts_on(yesterday)).to eq yesterday
    end

    it 'returns the today when given no date' do
      video_tutorial = build(:video_tutorial)

      expect(video_tutorial.starts_on).to eq Time.zone.today
    end
  end

  describe 'ends_on' do
    it 'returns the date equal to the given date plus the length of the video_tutorial' do
      video_tutorial = build(:video_tutorial, length_in_days: 28)
      yesterday = 1.day.ago.to_date

      expect(video_tutorial.ends_on(yesterday)).to eq (yesterday + 28.days)
    end

    it 'returns the date equal to today plus the length of the video_tutorial when given no date' do
      ends_on = 14.days.from_now.to_date
      video_tutorial = build(:video_tutorial, length_in_days: 14)

      expect(video_tutorial.ends_on).to eq ends_on
    end
  end

  describe '#collection?' do
    it 'should be true' do
      expect(VideoTutorial.new).to be_collection
    end
  end

  describe '#to_aside_partial' do
    it 'returns the path to the aside partial' do
      expect(VideoTutorial.new.to_aside_partial).to eq 'video_tutorials/aside'
    end
  end
end
