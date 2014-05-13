require 'spec_helper'

describe Wistia do
  context '.get_media_hash_from_id' do
    it 'returns the response body as a hash' do
      data = { 'some_key' => 'some_value' }
      stub_request(:get, /api.wistia.com\/v1\/medias/).
        to_return(header: { 'Content-Type' => 'text/json' }, body: data)

      expect(Wistia.get_media_hash_from_id(1)).to eq data
    end
  end
end
