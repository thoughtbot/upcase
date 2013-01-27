require 'spec_helper'

describe VideosHelper, '#video_availability_class' do
  it 'returns available for videos available to a section' do
    section = stub(:video_available? => true)
    video = stub
    expect(helper.video_availability_class(video, section)).to eq 'available'
  end

  it 'returns unavailable for videos available to a section' do
    section = stub(:video_available? => false)
    video = stub
    expect(helper.video_availability_class(video, section)).to eq 'unavailable'
  end
end
