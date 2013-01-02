# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/autorun'
require 'rspec/rails'
require 'paperclip/matchers'
require "email_spec"
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow_localhost => true)

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

FakeFreshbooks.reset!
ShamRack.mount(FakeFreshbooks.new, FRESHBOOKS_PATH, 443)
FakeStripeRunner.boot

Delayed::Worker.delay_jobs = false

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Methods

  config.mock_with :mocha
end
