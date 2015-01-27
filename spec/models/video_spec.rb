require "rails_helper"

describe Video do
  it { should belong_to(:watchable) }
  it { should have_many(:classifications) }
  it { should have_many(:statuses).dependent(:destroy) }
  it { should have_many(:steps).dependent(:destroy) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:trails).through(:steps) }
  it { should have_many(:users).through(:teachers) }

  it { should validate_presence_of(:published_on) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:watchable_id) }
  it { should validate_presence_of(:watchable_type) }
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
      Clip.stubs(:new)

      video.clip

      expect(Clip).to have_received(:new).with(video.wistia_id)
    end
  end

  context 'preview' do
    it 'returns a promo video if preview_wistia_id is set' do
      video = Video.new(preview_wistia_id: '123')
      Clip.stubs(:new)

      video.preview

      expect(Clip).to have_received(:new).with(video.preview_wistia_id)
    end

    it 'returns a thumbnail if preview_wistia_id is not set' do
      video = Video.new
      clip = stub(wistia_id: stub)
      Clip.stubs(:new).returns(clip)
      VideoThumbnail.stubs(:new)

      video.preview

      expect(VideoThumbnail).to have_received(:new).with(clip)
    end
  end

  context 'watchable_name' do
    it 'returns the name of the watchable' do
      video_tutorial = create(:video_tutorial, name: 'VideoTutorial')
      video = create(:video, watchable: video_tutorial)

      expect(video.watchable_name).to eq video_tutorial.name
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

  describe 'notes_html' do
    it "converts the video's notes to html" do
      video = build_stubbed(:video, notes: 'Some *awesome* markdown')

      expect(video.notes_html).to eq '<p>Some <em>awesome</em> markdown</p>'
    end
  end
end
