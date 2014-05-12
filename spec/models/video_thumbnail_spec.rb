require 'spec_helper'

describe VideoThumbnail do
  context '#url' do
    it 'returns the url' do
      url = stub
      thumbnail = VideoThumbnail.new(url)

      expect(thumbnail.url).to eq url
    end
  end
end
