require 'codeclimate-test-reporter'
CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end
CodeClimate::TestReporter.start

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/autorun'
require 'rspec/rails'
require 'paperclip/matchers'
require 'email_spec'
require 'webmock/rspec'
require 'clearance/testing'

WebMock.disable_net_connect!(allow_localhost: true, allow: 'codeclimate.com')

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

FakeStripeRunner.boot
FakeGithubRunner.boot

Delayed::Worker.delay_jobs = false

Capybara.javascript_driver = :webkit
Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.order = 'random'

  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Methods
  config.include Subscriptions
  config.include PurchaseHelpers
  config.include StripeHelpers
  config.include SessionHelpers, type: :feature
  config.include PaypalHelpers, type: :feature

  config.mock_with :mocha
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
