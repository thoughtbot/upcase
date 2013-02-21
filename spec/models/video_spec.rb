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
end
