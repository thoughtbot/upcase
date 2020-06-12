if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start :rails do
    add_filter "app/mailer_previews"
    add_filter "vendor/lib"
  end
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

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [
    Webdrivers::Common.subclasses.map(&:base_url),
    "codeclimate.com",
  ],
)

Webdrivers.cache_time = 86_400

Dir[File.expand_path(File.join(File.dirname(__FILE__),"support","**","*.rb"))].each {|f| require f}

FakeGithubRunner.boot
FakeWistiaRunner.boot

Capybara.app = HostMap.new(
  "www.example.com" => Capybara.app,
  "127.0.0.1" => Capybara.app,
  "github.com" => FakeGithub,
  "api.wistia.com" => FakeWistia,
  "exercises.upcase.com" => FakeUpcaseExercises,
  "localhost" => FakeUpcaseExercises
)

# Do not announce that capybara is starting puma
Capybara.server = :puma, { Silent: true }

silence_warnings do
  Clip::WISTIA_DOWNLOAD_BASE_URL = "localhost/"
end

Delayed::Worker.delay_jobs = false

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = true
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before(:each) { Analytics.backend = FakeAnalyticsRuby.new }

  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include AnalyticsHelper
  config.include Clearance::Testing::Matchers, type: :request
  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryBot::Syntax::Methods
  config.include SessionHelpers, type: :feature
  config.include SignInRequestHelpers, type: :request

  config.infer_spec_type_from_file_location!
end
