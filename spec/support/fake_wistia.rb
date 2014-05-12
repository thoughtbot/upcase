require 'sinatra/base'
require 'capybara_discoball'

class FakeWistia < Sinatra::Base
  get '/medias/:id.json' do
    headers 'Content-Type' => 'application/json'
    {
      hashed_id: 'abc123',
      assets: [{ type: 'OriginalFile', fileSize: 12345 }],
      duration: 5,
      thumbnail: {}
    }.to_json
  end
end

FakeWistiaRunner = Capybara::Discoball::Runner.new(FakeWistia) do |server|
  url = "http://#{server.host}:#{server.port}"
  Wistia.base_uri(url)
end
