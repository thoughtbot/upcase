require 'sinatra/base'
require 'capybara_discoball'

class FakeGithub < Sinatra::Base
  disable :protection

  put "/teams/:team_id/memberships/:id" do
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

  get '/users/:username/keys' do
    content_type :json

    [{ 'id' => 1, 'key' => 'ssh-rsa AAA' }].to_json
  end

  not_found do
    content_type :json

    { 'error' => "Edit #{__FILE__} to fake out this request" }.to_json
  end
end

class HostMap
  def initialize(mappings)
    @mappings = mappings
  end

  def call(env)
    app_for(env["SERVER_NAME"]).call(env)
  end

  private

  def app_for(server_name)
    @mappings[server_name] || NOT_FOUND
  end

  NOT_FOUND = lambda do |env|
    [
      404,
      { "Content-Type" => "text/html" },
      ["Unmapped server name: #{env["SERVER_NAME"]}"]
    ]
  end
end

FakeGithubRunner = Capybara::Discoball::Runner.new(FakeGithub) do |server|
  url = "http://#{server.host}:#{server.port}"
  Octokit.api_endpoint = url
end

Capybara.app = HostMap.new(
  "www.example.com" => Capybara.app,
  "127.0.0.1" => Capybara.app,
  "github.com" => FakeGithub
)
