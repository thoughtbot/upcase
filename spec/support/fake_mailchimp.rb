require 'sinatra/base'
require 'capybara_discoball'
require 'gibbon'

RSpec.configure do |config|
  config.after(:each) do
    FakeMailchimp.clear_errors!
  end
end

class FakeMailchimp < Sinatra::Base
  set :show_exceptions, false

  cattr_reader :lists
  cattr_accessor :master_list
  cattr_accessor :email_error_response

  post '/1.3/' do
    send(params[:method].to_sym, JSON.parse(params.keys.second))
  end

  def self.clear_errors!
    @@email_error_response = nil
  end

  def lists(params)
    initialize_lists params['filters']['list_name']

    {
      total: 1,
      data: [{
        id: params['filters']['list_name']
      }]
    }.to_json
  end

  def listUnsubscribe(params)
    respond_with_error_or do
      initialize_lists params['id']

      @@lists[params['id']].delete params['email_address']
      ''
    end
  end

  def listSubscribe(params)
    respond_with_error_or do
      initialize_lists params['id']

      if params['double_optin'] == false
        @@lists[params['id']] << params['email_address']
      end
      ''
    end
  end

  def initialize_lists(list)
    @@lists ||= {}
    @@lists[master_list] ||= []
    @@lists[list] ||= []
  end

  def respond_with_error_or
    if email_error_response.blank?
      yield
    else
      email_error_response.to_json
    end
  end
end

FakeMailchimpRunner = Capybara::Discoball::Runner.new(FakeMailchimp) do |server|
  url = "http://#{server.host}:#{server.port}"

  ::Gibbon.api_endpoint = url
end
