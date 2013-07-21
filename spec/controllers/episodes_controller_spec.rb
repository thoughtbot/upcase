require 'spec_helper'

describe EpisodesController do
  describe '#index' do
    it 'renders the response with etag and last_modified' do
      episode = create(:episode)
      get :index
      key = ActiveSupport::Cache.expand_cache_key(episode)
      etag = %("#{Digest::MD5.hexdigest(key)}")
      response.headers["ETag"].should eq etag
      response.headers["Last-Modified"].should eq episode.updated_at.httpdate
    end
  end

  describe '#index as xml' do
    it 'renders the index template for published episodes' do
      Episode.stubs(:published).returns([build_stubbed(:episode)])
      get :index, format: :xml
      Episode.should have_received(:published)
      response.should render_template("index")
    end
  end

  describe '#show as html' do
    it 'renders the show template for the episode' do
      episode = build_stubbed(:episode, number: 1)
      Episode.stubs(:find_by_number!).returns(episode)

      get :show, id: episode.to_param, format: :html

      expect(Episode).to have_received(:find_by_number!).with(episode.to_param)
      expect(response).to render_template("show")
    end
  end

  describe '#show as mp3' do
    it 'increments the download counter and 302 redirects to the mp3' do
      episode = create(:episode, mp3: episode_mp3_fixture)

      expect(episode.downloads_count).to eq 0
      get :show, id: episode.to_param, format: :mp3
      episode.reload

      expect(episode.downloads_count).to eq 1
      expect(response).to redirect_to(episode.mp3.url(:id3))
      expect(response.code).to eq '302'
    end
  end
end
