require "rails_helper"

describe VideoThumbnail, type: :model do
  context '#url' do
    it 'returns the url' do
      wistia_id = stub
      clip = stub(wistia_id: wistia_id)
      thumbnail = VideoThumbnail.new(clip)

      expect(thumbnail.wistia_id).to eq wistia_id
    end
  end
end
