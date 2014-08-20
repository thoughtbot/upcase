require "codeclimate-test-reporter"

CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end

CodeClimate::TestReporter.start

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails"
end

ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "clearance/rspec"
require "email_spec"
require "paperclip/matchers"
require "rspec/rails"
require "webmock/rspec"
require "shoulda/matchers"

WebMock.disable_net_connect!(allow_localhost: true, allow: "codeclimate.com")

Dir[File.expand_path(File.join(File.dirname(__FILE__),"support","**","*.rb"))].each {|f| require f}

FakeStripeRunner.boot
FakeGithubRunner.boot
FakeWistiaRunner.boot

silence_warnings do
  Clip::WISTIA_EMBED_BASE_URL = "localhost/"
end

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

  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Methods
  config.include Subscriptions
  config.include CheckoutHelpers
  config.include StripeHelpers
  config.include SessionHelpers, type: :feature
  config.include PathHelpers, type: :feature

  config.infer_spec_type_from_file_location!
end
