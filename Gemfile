source "https://rubygems.org"

ruby "2.2.3"

gem "mime-types", '~> 2.6', require: 'mime/types/columnar'

gem "active_model_serializers", "0.8.3"
gem "acts_as_list", "~> 0.6.0"
gem "airbrake"
gem "analytics-ruby", "~> 2.0.0", require: "segment/analytics"
gem "autoprefixer-rails"
gem "aws-sdk"
gem "bourbon", "~> 4.0"
gem "clearance", "~> 1.8.0"
gem "coffee-rails"
gem "delayed_job_active_record", "~> 4.0.3"
gem "doorkeeper", "2.1.2"
gem "dynamic_form", "~> 1.1.4"
gem "flutie"
gem "font-awesome-rails"
gem "formtastic", "~> 3.1.3"
gem "friendly_id", "~> 5.1.0"
gem "gravatarify", "~> 3.1.0"
gem "heroku-deflater"
gem "high_voltage"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "neat"
gem "nokogiri", ">= 1.6.7.2"
gem "octokit", "~> 3.5.2"
gem "omniauth", "~> 1.2.1"
gem "omniauth-github", "~> 1.1.2"
gem "paperclip", "~> 4.2.2"
gem "pg"
gem "pg_search"
gem "pry-rails"
gem "puma"
gem "rack-canonical-host"
gem "rack-rewrite", "~> 1.5.1"
gem "rails", "~> 4.2.5"
gem "rails_admin", "~> 0.6.7"
gem "recipient_interceptor"
gem "redcarpet"
gem "request_store"
gem "responders", "~> 2.0"
gem "sass-rails"
gem "scenic"
gem "sprockets-rails", "~> 2.3"
gem "sprockets-redirect"
gem "stripe"
gem "stripe_event"
gem "uglifier"
gem "validates_email_format_of"
gem "vanity", "2.0.0.beta8"
gem "wrapped"

group :development do
  gem "quiet_assets"
  gem "rack-mini-profiler", require: false
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "rspec-rails"
end

group :production, :staging do
  gem "font_assets"
  gem "rails_12factor"
  gem "skylight"
end

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "capybara_discoball", git: "https://github.com/thoughtbot/capybara_discoball"
  gem "climate_control"
  gem "codeclimate-test-reporter", require: nil
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_girl_rails"
  gem "launchy"
  gem "shoulda-matchers", require: false
  gem "simplecov", "~> 0.9", require: false
  gem "sinatra"
  gem "timecop"
  gem "webmock"
end
