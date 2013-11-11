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

  context '#wistia_thumbnail' do
    it 'returns the thumbnail cached from wistia' do
      video = build_stubbed(:video,
        wistia_hash: { 'thumbnail' => { 'url' => 'http://images.com/hi.jpg' } })
      video.wistia_thumbnail.should == 'http://images.com/hi.jpg'
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

      expect(video.has_notes?).to be_true
    end

    it 'returns false for videos with empty or no notes' do
      video_one = build_stubbed(:video)
      video_two = build_stubbed(:video, notes: '')

      expect(video_one.has_notes?).to be_false
      expect(video_two.has_notes?).to be_false
    end
  end

  describe 'notes_html' do
    it "converts the video's notes to html" do
      video = build_stubbed(:video, notes: 'Some *awesome* markdown')

      expect(video.notes_html).to eq "<p>Some <em>awesome</em> markdown</p>"
    end
  end
end
