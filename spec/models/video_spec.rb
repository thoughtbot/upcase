require "rails_helper"

describe Video do
  it { should belong_to(:watchable) }
  it { should have_many(:classifications) }
  it { should have_many(:markers) }
  it { should have_many(:statuses).dependent(:destroy) }
  it { should have_many(:teachers).dependent(:destroy) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:users).through(:teachers) }
  it { should have_one(:step).dependent(:destroy) }
  it { should have_one(:trail).through(:step) }

  it { should validate_presence_of(:published_on) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:wistia_id) }

  context "uniqueness" do
    before do
      create :video
    end

    it { should validate_uniqueness_of(:slug) }
  end

  describe "#to_param" do
    it "returns the slug" do
      video = create(:video)

      expect(video.to_param).to eq video.slug
    end
  end

  context 'self.ordered' do
    it 'returns videos in order by position' do
      video1 = create(:video, position: 2)
      video2 = create(:video, position: 1)

      expect(Video.ordered).to eq [video2, video1]
    end
  end

  context 'self.published' do
    it 'returns only published videos' do
      Timecop.freeze(Time.zone.now) do
        published_videos = [
          create(:video, published_on: 1.day.ago.to_date),
          create(:video, published_on: Time.zone.today),
        ]
        unpublished_videos = [
          create(:video, published_on: 1.day.from_now.to_date)
        ]

        expect(Video.published).to match_array(published_videos)
        expect(Video.published).not_to match_array(unpublished_videos)
      end
    end
  end

  context '.recently_published_first' do
    it 'sorts the collection so that recently published videos are first' do
      create(:video, published_on: Date.today, name: 'new')
      create(:video, published_on: 2.days.ago, name: 'old')
      create(:video, published_on: Date.yesterday, name: 'middle')
      names = %w(new middle old)

      expect(Video.recently_published_first.map(&:name)).to eq names
    end
  end

  context 'video' do
    it 'creates a Video object with the correct wistia_id' do
      video = Video.new(wistia_id: '123')
      allow(Clip).to receive(:new)

      video.clip

      expect(Clip).to have_received(:new).with(video.wistia_id)
    end
  end

  context 'preview' do
    it 'returns a promo video if preview_wistia_id is set' do
      video = Video.new(preview_wistia_id: '123')
      allow(Clip).to receive(:new)

      video.preview

      expect(Clip).to have_received(:new).with(video.preview_wistia_id)
    end

    it 'returns a thumbnail if preview_wistia_id is not set' do
      video = Video.new
      clip = double("Clip", wistia_id: double)
      allow(Clip).to receive(:new).and_return(clip)
      allow(VideoThumbnail).to receive(:new)

      video.preview

      expect(VideoThumbnail).to have_received(:new).with(clip)
    end
  end

  context "has_preview_clip?" do
    it "returns true if there is a preview clip present" do
      video = Video.new(preview_wistia_id: "abc124")

      expect(video.has_preview_clip?).to eq(true)
    end

    it "returns false if there is not a preview clip present" do
      video = Video.new(preview_wistia_id: "")

      expect(video.has_preview_clip?).to eq(false)
    end
  end

  context "watchable_name" do
    it "returns the name of the watchable" do
      show = create(:show, name: "A show")
      video = create(:video, watchable: show)

      expect(video.watchable_name).to eq show.name
    end
  end

  describe 'has_notes?' do
    it 'returns true when the video has notes' do
      video = build_stubbed(:video, notes: 'Some notes')

      expect(video).to have_notes
    end

    it 'returns false for videos with empty or no notes' do
      video_one = build_stubbed(:video)
      video_two = build_stubbed(:video, notes: '')

      expect(video_one).not_to have_notes
      expect(video_two).not_to have_notes
    end
  end

  describe "summary_or_notes" do
    context "when there is summary text" do
      it "returns the summary" do
        video = build_stubbed(:video, summary: "hello world", notes: "nope")

        expect(video.summary_or_notes).to eq("hello world")
      end
    end

    context "when there is no summary text defined" do
      it "returns the notes" do
        video = build_stubbed(:video, summary: "", notes: "notes please")

        expect(video.summary_or_notes).to eq("notes please")
      end
    end
  end

  describe "#watchable" do
    context "for a video with a watchable" do
      it "returns the watchable directly" do
        show = build_stubbed(:show)
        video = build_stubbed(:video, watchable: show)

        result = video.watchable

        expect(result).to eq(show)
      end
    end

    context "for a video with a step" do
      it "returns the trail" do
        trail = build_stubbed(:trail)
        step = build_stubbed(:step, trail: trail)
        video = build_stubbed(:video, step: step, watchable: nil)

        result = video.watchable

        expect(result).to eq(trail)
      end
    end

    context "for an unsaved video" do
      it "returns nil" do
        video = Video.new

        result = video.watchable

        expect(result).to be_nil
      end
    end
  end

  describe "#part_of_trail?" do
    context "when the video is part of a trail" do
      it "returns true" do
        video = create(:video, :with_trail)

        expect(video.reload).to be_part_of_trail
      end
    end

    context "when the video is not part of a trail" do
      it "returns false" do
        video = build_stubbed(:video)

        expect(video).not_to be_part_of_trail
      end
    end
  end

  describe "#search_visible?" do
    context "it is not part of a trail" do
      it "returns true" do
        video = create(:video)

        expect(video).to be_search_visible
      end
    end

    context "it is part of a published trail" do
      it "returns true" do
        trail = build_stubbed(:trail, published: true)
        video = create(:video, watchable: trail)

        expect(video).to be_search_visible
      end
    end

    context "it is part of an unpublished trail" do
      it "returns false" do
        trail = create(:trail, published: false)
        video = create(:video)
        create(:step, trail: trail, completeable: video)

        expect(video.reload).not_to be_search_visible
      end
    end
  end

  describe "#state_for" do
    it "finds the state for the user" do
      user = create(:user)
      video = create(:video)
      status = create(:status, :completed, completeable: video, user: user)

      result = video.state_for(user)

      expect(result).to eq(status.state)
    end
  end

  describe "#download_url" do
    it { should delegate_method(:download_url).to(:clip) }
  end
end
