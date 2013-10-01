require 'sinatra/base'
require 'capybara_discoball'

class FakeGithub < Sinatra::Base
  put '/teams/:team_id/members/:id' do
    content_type :json

    {}.to_json
  end

  delete '/teams/:team_id/members/:id' do
    content_type :json

    {}.to_json
  end

  get '/teams/:team_id/members/:id' do
    content_type :json

    {}.to_json
  end
end

FakeGithubRunner = Capybara::Discoball::Runner.new(FakeGithub) do |server|
  url = server.url('')
  Octokit.api_endpoint = url
end
