require 'spec_helper'

describe EpisodesController do
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
      episode = build_stubbed(:episode)
      Episode.stubs(:find).returns(episode)
      get :show, id: episode.to_param, format: :html
      Episode.should have_received(:find).with(episode.to_param)
      response.should render_template("show")
    end
  end

  describe '#show as mp3' do
    it 'increments the download counter and 302 redirects to the file' do
      episode = build_stubbed(:episode, file: 'http://amazon.com')
      episode.stubs(:increment_downloads)
      Episode.stubs(find: episode)
      get :show, id: episode.to_param, format: :mp3
      episode.should have_received(:increment_downloads)
      response.should redirect_to('http://amazon.com')
      response.code.should eq '302'
    end
  end
end
