require 'sinatra/base'
require 'oauth2'


class FakeOauthClientApp < Sinatra::Base
  include Rails.application.routes.url_helpers

  disable :dump_errors
  disable :logging

  REDIRECT_PATH = '/fake_oauth_client_app/authorize'

  cattr_accessor :client_id
  cattr_accessor :client_secret
  cattr_accessor :server_url

  def self.redirect_uri
    URI.parse(client_url).merge(REDIRECT_PATH).to_s
  end

  get '/fake_oauth_client_app' do
    auth_url = client.auth_code.authorize_url(redirect_uri: self.class.redirect_uri)
    %{<a href="#{auth_url}">Sign Into Learn</a>}
  end

  get '/fake_oauth_client_app/authorize' do
    token_response = client.auth_code.get_token(params[:code], redirect_uri: self.class.redirect_uri)

    %{<div id='data' type='application/json'>#{token_response.get(resource_owner_path).body}</div>}
  end

  def client
    OAuth2::Client.new(
      client_id,
      client_secret,
      site: server_url
    )
  end

  def self.client_url
    @client_url ||= boot
  end

  def self.boot
    Capybara::Discoball.spin(FakeOauthClientApp) do |client|
      client.url('')
    end
  end
end
