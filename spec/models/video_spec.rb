require 'spec_helper'

describe Video do
  it { should belong_to(:watchable) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:watchable_id) }
  it { should validate_presence_of(:watchable_type) }
  it { should validate_presence_of(:wistia_id) }

  context 'self.ordered' do
    it 'returns videos in order by position' do
      video1 = create(:video, position: 2)
      video2 = create(:video, position: 1)
      Video.ordered.should == [video2, video1]
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
          create(:video, published_on: 1.day.from_now.to_date),
          create(:video, published_on: nil),
        ]

        expect(Video.published).to match_array(published_videos)
        expect(Video.published).not_to match_array(unpublished_videos)
      end
    end
  end

  context '.recently_published_first' do
    it 'sorts the collection so that recently published videos are first' do
      create(:video, published_on: Date.today, title: 'new')
      create(:video, published_on: 2.days.ago, title: 'old')
      create(:video, published_on: Date.yesterday, title: 'middle')

      expect(Video.recently_published_first.map(&:title)).to eq ['new',
                                                                 'middle',
                                                                 'old']
    end
  end

  context '#wistia_thumbnail' do
    it 'returns the thumbnail cached from wistia' do
      video = build_stubbed(:video,
        wistia_hash: { 'thumbnail' => { 'url' => 'http://images.com/hi.jpg' } })
      video.wistia_thumbnail.should == 'http://images.com/hi.jpg'
    end
  end

  context '#full_sized_wistia_thumbnail' do
    it 'returns the full sized thumbnail cached from wistia' do
      video = build_stubbed(:video,
        wistia_hash: {
          'thumbnail' => {
            'url' => 'http://images.com/hi.jpg?image_crop_resized=100x60'
          }
        }
      )
      video.full_sized_wistia_thumbnail.should == 'http://images.com/hi.jpg'
    end
  end

  context '#preview_video_hash_id' do
    it 'returns the video_hash_id for the preview video' do
      video = Video.new(preview_wistia_id: '123')
      wistia_hash = { 'hashed_id' => stub }
      Wistia.stubs(:get_media_hash_from_id).with('123').returns(wistia_hash)

      hash_id = video.preview_video_hash_id

      expect(hash_id).to eq wistia_hash['hashed_id']
    end
  end

  context 'watchable_name' do
    it 'returns the name of the watchable' do
      workshop = create(:workshop, name: 'Workshop')
      video = create(:video, watchable: workshop)

      expect(video.watchable_name).to eq workshop.name
    end
  end

  describe 'has_notes?' do
    it 'returns true when the video has notes' do
      video = build_stubbed(:video, notes: "Some notes")

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

      expect(video.notes_html).to eq "<p>Some <em>awesome</em> markdown</p>"
    end
  end
end
