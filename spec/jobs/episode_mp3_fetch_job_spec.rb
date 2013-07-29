require 'spec_helper'

describe EpisodeMp3FetchJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'adds given usernames to a github team' do
    episode = stub(:id => 1, :"mp3=" => nil, :save! => true)
    Episode.stubs(find: episode)
    url = 'http://example.com/test.mp3'

    EpisodeMp3FetchJob.new(episode.id, url).perform

    Episode.should have_received(:find).with(episode.id)
    episode.should have_received(:"mp3=").with(URI.parse(url))
    episode.should have_received(:save!)
  end
end
