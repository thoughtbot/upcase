require 'spec_helper'

describe Video do
  context '#wistia_thumbnail' do
    it 'returns the thumbnail cached from wistia' do
      video = build_stubbed(:video,
        wistia_hash: { thumbnail: { url: 'http://images.com/hi.jpg' } }.to_json)
      video.wistia_thumbnail.should == 'http://images.com/hi.jpg'
    end
  end

  context '#wistia_running_time' do
    it "converts wistia's duration in seconds to running time in MM:SS" do
      video = build_stubbed(:video,
        wistia_hash: { duration: '2052.97' }.to_json)
      video.wistia_running_time.should == '34:12'
    end
  end
end
