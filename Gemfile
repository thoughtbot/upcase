source "https://rubygems.org"

ruby "2.7.1"

git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}.git"
end

gem "active_model_serializers"
gem "acts_as_list"
gem "analytics-ruby", require: "segment/analytics"
gem "autoprefixer-rails"
gem "aws-sdk-s3"
gem "bootsnap"
gem "bourbon"
gem "clearance"
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
gem "kaminari"
gem "mime-types"
gem "neat", "~> 1.9.1"
gem "nokogiri", ">= 1.6.7.2"
gem "octokit"
gem "omniauth"
gem "omniauth-github"
gem "paperclip"
gem "pg"
gem "pg_search"
gem "pry-byebug"
gem "pry-rails"
gem "puma"
gem "rack-rewrite", "~> 1.5.1"
gem "rails", "~> 6.0.3"
gem "rails_admin"
gem "recipient_interceptor"
gem "redcarpet"
gem "redis", "~> 4.1"
gem "request_store"
gem "responders", "~> 3.0"
gem "sassc"
gem "scenic"
gem "sprockets-rails"
gem "sprockets-redirect"
gem "uglifier"
gem "validates_email_format_of"
gem "vanity"
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
  gem "capybara-selenium"
  gem "capybara_discoball"
  gem "climate_control"
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_bot_rails"
  gem "launchy"
  gem "rails-controller-testing"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "sinatra"
  gem "timecop"
  gem "webdrivers"
  gem "webmock"
end
