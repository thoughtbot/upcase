require 'sinatra/base'
require 'capybara_discoball'
require 'gibbon'

class FakeMailchimp < Sinatra::Base
  set :show_exceptions, false

  cattr_reader :lists
  cattr_accessor :master_list

  post '/1.3/' do
    send(params[:method].to_sym, JSON.parse(params.keys.second))
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
    initialize_lists params['id']

    @@lists[params['id']].delete params['email_address']
    ''
  end

  def listSubscribe(params)
    initialize_lists params['id']

    if params['double_optin']
      @@lists[params['id']] << params['email_address']
    end
    ''
  end

  def initialize_lists(list)
    @@lists ||= {}
    @@lists[master_list] ||= []
    @@lists[list] ||= []
  end
end

FakeMailchimpRunner = Capybara::Discoball::Runner.new(FakeMailchimp) do |server|
  url = server.url('')

  ::Gibbon.api_endpoint = url
end
