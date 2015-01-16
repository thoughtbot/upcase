require "rails_helper"

describe VideoTutorial do
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:tagline) }
  it { should validate_presence_of(:sku) }

  describe "#to_param" do
    it "returns the slug" do
      video_tutorial = create(:video_tutorial)
      expect(video_tutorial.to_param).to eq video_tutorial.slug
    end
  end

  describe "title" do
    it "describes the video_tutorial name" do
      video_tutorial = build_stubbed(:video_tutorial, name: "Billy")

      result = video_tutorial.title

      expect(result).to eq "Billy: a video tutorial by thoughtbot"
    end
  end

  describe "#meta_keywords" do
    it { should delegate(:meta_keywords).to(:topics) }
  end

  describe "offering_type" do
    it "returns video_tutorial" do
      video_tutorial = VideoTutorial.new

      result = video_tutorial.offering_type

      expect(result).to eq "video_tutorial"
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

  describe "#subscription?" do
    it "returns false" do
      expect(VideoTutorial.new).not_to be_subscription
    end
  end

  describe "#collection?" do
    it "is a collection if there is more than one published video" do
      video_tutorial = create(:video_tutorial)
      create_list(:video, 2, :published, watchable: video_tutorial)

      expect(video_tutorial).to be_collection
    end

    it "is not a collection if there is 1 published video or less" do
      video_tutorial = create(:video_tutorial)

      expect(video_tutorial).not_to be_collection

      create(:video, :published, watchable: video_tutorial)
      create(:video, watchable: video_tutorial)

      expect(video_tutorial).not_to be_collection
    end
  end

  describe "#teachers" do
    it "returns unique teachers from its videos" do
      only_first = create(:user, name: "only_first")
      only_second = create(:user, name: "only_second")
      both = create(:user, name: "both")
      video_tutorial = create(:video_tutorial)
      create(
        :video,
        watchable: video_tutorial,
        teachers: [teacher(both), teacher(only_first)]
      )
      create(
        :video,
        watchable: video_tutorial,
        teachers: [teacher(both), teacher(only_second)]
      )

      result = video_tutorial.teachers

      expect(result.map(&:name)).to match_array(%w(only_first only_second both))
    end

    def teacher(user)
      Teacher.create!(user: user)
    end
  end

  describe "#to_aside_partial" do
    it "returns the path to the aside partial" do
      expect(VideoTutorial.new.to_aside_partial).to eq "video_tutorials/aside"
    end
  end
end
