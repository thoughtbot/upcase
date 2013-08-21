require 'spec_helper'

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
