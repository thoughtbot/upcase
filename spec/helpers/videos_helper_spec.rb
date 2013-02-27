require 'spec_helper'

describe VideosHelper, '#video_availability_class' do
  it 'returns available for videos available to a section' do
    section = stub(starts_on: Date.today)
    video = stub(:available? => true)
    expect(helper.video_availability_class(video, section)).to eq 'available'
  end

  it 'returns unavailable for videos available to a section' do
    section = stub(starts_on: Date.today)
    video = stub(:available? => false)
    expect(helper.video_availability_class(video, section)).to eq 'unavailable'
  end
end

describe VideosHelper, '#single_video?' do
  it 'returns true for purchaseables with only one video' do
    videos = stub(size: 1)
    purchaseable = stub(videos: videos)
    expect(helper.single_video?(purchaseable)).to be_true

    videos = stub(size: 2)
    purchaseable = stub(videos: videos)
    expect(helper.single_video?(purchaseable)).to be_false
  end
end
