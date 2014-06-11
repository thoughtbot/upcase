require 'sinatra/base'
require 'capybara_discoball'

class FakeWistia < Sinatra::Base
  get '/oembed.json' do
    headers 'Access-Control-Allow-Origin' => '*'
    {
      html: "<iframe class='wistia_embed'></iframe>",
      thumbnail_url: 'https://embed-ssl.wistia.com',
      duration: 120
    }.to_json
  end
end

FakeWistiaRunner = Capybara::Discoball::Runner.new(FakeWistia) do |server|
  url = "http://#{server.host}:#{server.port}"
  ENV['WISTIA_HOST'] = url
end
