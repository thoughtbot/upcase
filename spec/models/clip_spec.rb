require 'spec_helper'

describe Clip, :type => :model do
  context '#download_url' do
    it 'returns the download url for the video' do
      video = Clip.new('123')

      url = video.download_url('original')
      expected_url = 'http://thoughtbotlearn.wistia.com/medias/123/download?asset=original'

      expect(url).to eq expected_url
    end
  end
end
