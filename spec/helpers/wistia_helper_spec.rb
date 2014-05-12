require 'spec_helper'

describe WistiaHelper do
  it 'returns an iframe with src' do
    video = stub(embed_url: stub)
    iframe = helper.wistia_video_embed(video)

    expect(iframe).to include 'iframe'
    expect(iframe).to include 'src'
  end
end
