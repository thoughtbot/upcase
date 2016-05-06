require "rails_helper"

describe Topic do
  # Associations
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:products).through(:classifications) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:videos).through(:classifications) }
  it { should have_many(:trails) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      expect(@topic.slug).to eq "test-driven-development"
    end
  end

  describe ".explorable" do
    it "finds topics with explorable flag set to true" do
      visible_topic = create(:topic, :explorable)
      _hidden_topic = create(:topic, explorable: false)

      result = Topic.explorable.map(&:slug)

      expect(result).to eq([visible_topic.slug])
    end
  end

  context 'validations' do
    context 'uniqueness' do
      before do
        create :topic
      end

      it { should validate_uniqueness_of(:slug) }
    end
  end

  describe "#weekly_iteration_videos" do
    it "returns only videos from the weekly iteration, not from trails" do
      topic = create(:topic, name: "Rails")
      show = create(:the_weekly_iteration)
      video = create(:video, name: "Railsy", watchable: show, topics: [topic])
      create_trail_video(topic)

      expect(topic.weekly_iteration_videos.pluck(:name)).to eq([video.name])
    end
  end

  def create_trail_video(topic)
    create(:trail, :published, name: "Video Trail").tap do |trail|
      video = create(:video, watchable: trail, topics: [topic])
      create(:step, trail: trail, completeable: video)
    end
  end
end
