require "rails_helper"

describe VideoTutorial do
  # Associations
  it { should have_many(:classifications) }
  it { should have_many(:downloads) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:teachers).dependent(:destroy) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:users).through(:teachers) }
  it { should have_many(:videos) }

  # Validations
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:tagline) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:length_in_days) }

  describe "#to_param" do
    it "returns the slug" do
      video_tutorial = create(:video_tutorial)
      expect(video_tutorial.to_param).to eq video_tutorial.slug
    end
  end

  describe 'title' do
    it 'describes the video_tutorial name' do
      video_tutorial = build_stubbed(:video_tutorial, name: 'Billy')

      result = video_tutorial.title

      expect(result).to eq 'Billy: a video tutorial by thoughtbot'
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

  describe '#to_aside_partial' do
    it 'returns the path to the aside partial' do
      expect(VideoTutorial.new.to_aside_partial).to eq 'video_tutorials/aside'
    end
  end
end
