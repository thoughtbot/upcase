require 'spec_helper'

describe Clip do
  context '#thumbnail' do
    it 'returns the thumbnail cached from wistia' do
      video = Clip.new('123')
      wistia_hash = { 'thumbnail' => { 'url' => 'http://images.com/hi.jpg' } }
      Wistia.stubs(:get_media_hash_from_id).with('123').returns(wistia_hash)
      expect(video.thumbnail).to eq 'http://images.com/hi.jpg'
    end
  end

  context '#full_sized_thumbnail' do
    it 'returns the full sized thumbnail cached from wistia' do
      video = Clip.new('123')
      wistia_hash = {
        'thumbnail' => {
          'url' => 'http://images.com/hi.jpg?image_crop_resized=100x60'
        }
      }
      Wistia.stubs(:get_media_hash_from_id).with('123').returns(wistia_hash)

      expect(video.full_sized_thumbnail).to eq 'http://images.com/hi.jpg'
    end
  end

  context '#running_time' do
    it 'returns the running time' do
      video = Clip.new('123')
      wistia_hash = { 'duration' => double }
      Wistia.stubs(:get_media_hash_from_id).with('123').returns(wistia_hash)

      expect(video.running_time).to eq wistia_hash['duration']
    end
  end

  context '#sizes' do
    it 'returns the sizes' do
      video = Clip.new('123')
      wistia_hash = {
        'assets' => [
          { 'type' => 'small', 'fileSize' => '12345'},
          { 'type' => 'large', 'fileSize' => '98765'}
        ]
      }
      Wistia.stubs(:get_media_hash_from_id).with('123').returns(wistia_hash)

      expect(video.sizes).to eq({ 'small' => '12.1 KB', 'large' => '96.5 KB' })
    end
  end

  context '#embed_url' do
    it 'returns the embed url for the video' do
      video = Clip.new('123')
      wistia_hash = { 'hashed_id' => 'abc123' }
      Wistia.stubs(:get_media_hash_from_id).with('123').returns(wistia_hash)

      url = video.embed_url(:large)
      expected_url = Clip::WISTIA_EMBED_BASE_URL +
        'abc123?videoWidth=653&videoHeight=367&controlsVisibleOnLoad=true'

      expect(url).to eq expected_url
    end
  end

  context '#download_url' do
    it 'returns the download url for the video' do
      video = Clip.new('123')

      url = video.download_url('original')
      expected_url = 'http://thoughtbotlearn.wistia.com/medias/123/download?asset=original'

      expect(url).to eq expected_url
    end
  end
end
