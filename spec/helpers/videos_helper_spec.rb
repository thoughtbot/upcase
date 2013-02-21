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
