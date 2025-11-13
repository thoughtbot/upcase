if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start :rails do
    enable_coverage :branch
    add_filter "app/mailer_previews"
    add_filter "vendor/lib"
  end
end

TracePoint.trace(:raise) do |tp|
  if tp.raised_exception.is_a?(FrozenError) && tp.raised_exception.message.include?("can't modify frozen Array")
    puts "=" * 80
    puts "FROZEN ERROR CAUGHT"
    puts "Message: #{tp.raised_exception.message}"
    puts "Location: #{tp.path}:#{tp.lineno}"
    puts "\nBacktrace (first 30 lines):"
    puts tp.raised_exception.backtrace.first(30).join("\n")
    puts "=" * 80
  end
end
trace = TracePoint.new(:call, :return) do |tp|
  if tp.defined_class == Array && tp.method_id == :freeze
    caller_info = caller(1, 5).join("\n  ")
    puts "ARRAY FROZEN at #{tp.path}:#{tp.lineno}"
    puts "  Caller:\n  #{caller_info}"
  end
end

ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
# require File.expand_path("../../config/environment", __FILE__)

trace.enable
require_relative "../config/environment"
trace.disable

require "clearance/rspec"
require "email_spec"
require "paperclip/matchers"
require "rspec/rails"
require "webmock/rspec"
require "shoulda/matchers"

WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support", "**", "*.rb"))].each { |f| require f }

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
Capybara.server = :puma, {Silent: true}

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
  config.raise_errors_for_deprecations!

  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures = false
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]

  config.include Clearance::Testing::Matchers, type: :request
  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryBot::Syntax::Methods
  config.include SessionHelpers, type: :feature
  config.include SignInRequestHelpers, type: :request

  config.infer_spec_type_from_file_location!
end
