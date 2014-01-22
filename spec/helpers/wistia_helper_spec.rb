require 'spec_helper'

describe WistiaHelper do
  it 'returns an iframe with no src' do
    iframe = helper.wistia_video_embed('hash')

    expect(iframe).to include 'iframe'
    expect(iframe).not_to include 'src'
  end

  context 'in a non-test environment' do
    before do
      env = stub(test?: false)
      Rails.stubs(env: env)
    end

    it 'returns an iframe with src' do
      iframe = helper.wistia_video_embed('hash')

      expect(iframe).to include 'iframe'
      expect(iframe).to include 'src'
    end
  end
end
