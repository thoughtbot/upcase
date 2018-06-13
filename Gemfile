source "https://rubygems.org"

ruby "2.5.1"

gem "mime-types", "~> 2.6", require: "mime/types/columnar"

gem "active_model_serializers", "0.8.3"
gem "acts_as_list"
gem "analytics-ruby", "~> 2.0.0", require: "segment/analytics"
# autoprefixer-rails 6.0+ prints a warning (not an error) about outdated
# `gradient` usage in rails-admin's CSS. In order to not show the warning, use a
# lower version until rails-admin has better CSS.
gem "autoprefixer-rails"
gem "aws-sdk", "~> 2.2"
gem "bourbon", "~> 4.0"
gem "clearance"
gem "clearance-deprecated_password_strategies"
gem "coffee-rails"
gem "delayed_job_active_record"
gem "doorkeeper"
gem "dynamic_form", "~> 1.1.4"
gem "flutie"
gem "font-awesome-rails"
gem "formtastic", "~> 3.1.3"
gem "friendly_id"
gem "gravatarify", "~> 3.1.0"
gem "high_voltage"
gem "honeybadger"
gem "inline_svg"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "neat", "~> 1.8"
gem "nokogiri", ">= 1.6.7.2"
gem "octokit"
gem "omniauth", "~> 1.3.2"
gem "omniauth-github", "~> 1.1.2"
gem "paperclip", "~> 5.2.0"
gem "pg"
gem "pg_search"
gem "pry-byebug"
gem "pry-rails"
gem "puma"
gem "rack-rewrite", "~> 1.5.1"
gem "rails", "~> 5.1.0"
gem "rails_admin"
gem "recipient_interceptor"
gem "redcarpet"
gem "request_store"
gem "responders", "~> 2.0"
gem "sass-rails"
gem "scenic"
gem "sprockets-rails"
gem "sprockets-redirect"
gem "stripe"
gem "stripe_event"
gem "uglifier"
gem "validates_email_format_of"
gem "vanity", "~> 2.0.0"
gem "wrapped"

source "https://rails-assets.org" do
  gem "rails-assets-lodash"
end

group :development do
  gem "guard-livereload", "~> 2.5", require: false
  gem "rack-livereload"
  gem "rack-mini-profiler", require: false
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "rspec-rails"
end

group :production do
  gem "rack-cors"
  gem "rails_stdout_logging"
  gem "skylight"
end

group :test do
  gem "capybara"
  gem "capybara-webkit", ">= 1.11.1"
  gem "capybara_discoball"
  gem "climate_control"
  gem "codeclimate-test-reporter", require: nil
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_bot_rails"
  gem "launchy"
  gem "rails-controller-testing"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "sinatra"
  gem "timecop"
  gem "webmock"
end
