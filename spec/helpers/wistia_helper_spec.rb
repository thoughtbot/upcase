require 'spec_helper'

describe WistiaHelper do
  it 'returns an iframe with src' do
    iframe = helper.wistia_video_embed('hash')

    expect(iframe).to include 'iframe'
    expect(iframe).to include 'src'
  end
end
