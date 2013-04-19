require 'spec_helper'

describe Video do
  it { should belong_to(:watchable) }
  it { should validate_presence_of(:watchable_id) }
  it { should validate_presence_of(:watchable_type) }
  it { should validate_presence_of(:wistia_id) }

  context 'self.ordered' do
    it 'returns videos in order by active_on_day and order' do
      video1 = create(:video, active_on_day: 37)
      video3 = create(:video, active_on_day: 1, position: 2)
      video2 = create(:video, active_on_day: 1, position: 1)
      Video.ordered.should == [video2, video3, video1]
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

  describe 'available?' do
    it 'returns true when the video is available based on the given start date' do
      video = create(:video, active_on_day: 0)
      expect(video.available?(Date.today)).to be_true
    end

    it 'returns false when the video is not available based on the given start date' do
      video = create(:video, active_on_day: 2)
      expect(video.available?(Date.today)).not_to be_true
    end
  end

  describe 'starts_today?' do
    it 'returns true when the video is available starting today based on the given start date' do
      video = create(:video, active_on_day: 0)
      expect(video.starts_today?(Date.today)).to be_true
    end

    it 'returns false when the video is not available starting today based on the given start date' do
      video = create(:video, active_on_day: 2)
      expect(video.starts_today?(Date.today)).not_to be_true
    end
  end

  describe 'available_on' do
    it 'gives the date the video will be available based on the given start date' do
      start_date = 7.days.from_now.to_date
      video_one = create(:video, active_on_day: 0)
      video_two = create(:video, active_on_day: 2)

      expect(video_one.available_on(start_date)).to eq 7.days.from_now.to_date
      expect(video_two.available_on(start_date)).to eq 9.days.from_now.to_date
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
end
