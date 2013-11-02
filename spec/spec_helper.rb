require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/autorun'
require 'rspec/rails'
require 'paperclip/matchers'
require 'email_spec'
require 'webmock/rspec'
require 'clearance/testing'
require 'capybara/poltergeist'

WebMock.disable_net_connect!(:allow_localhost => true)

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

FakeStripeRunner.boot
FakeMailchimpRunner.boot
FakeGithubRunner.boot

Delayed::Worker.delay_jobs = false

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Methods
  config.include Subscriptions
  config.include PurchaseHelpers

  config.mock_with :mocha
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
