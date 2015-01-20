source "https://rubygems.org"

ruby "2.2.0"

gem "active_model_serializers", "0.8.3"
gem "acts_as_list", "~> 0.6.0"
gem "airbrake"
gem "analytics-ruby", "~> 2.0.0", require: "segment/analytics"
gem "aws-sdk"
gem "bluecloth"
gem "bourbon", "~> 3.2.1"
gem "neat"
gem "clearance", "~> 1.7.0"
gem "coffee-rails"
gem "delayed_job_active_record", "~> 4.0.3"
gem "doorkeeper", "2.0.0"
gem "dynamic_form", "~> 1.1.4"
gem "flutie"
gem "formtastic", "~> 3.1.3"
gem "friendly_id", "~> 5.1.0"
gem "gravatarify", "~> 3.1.0"
gem "heroku-deflater"
gem "high_voltage"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "nokogiri", "~> 1.6.4"
gem "octokit", "~> 3.5.2"
gem "omniauth", "~> 1.2.1"
gem "omniauth-github", "~> 1.1.2"
gem "paperclip", "~> 4.2.0"
gem "pg"
gem "rack-rewrite", "~> 1.5.1"
gem "rack-ssl-enforcer", "~> 0.2.4"
gem "rails", "4.2.0"
gem "recipient_interceptor"
gem "responders", "~> 2.0"
gem "sass-rails", "~> 4.0.4"
gem "sprockets-redirect"
gem "stripe"
gem "stripe_event"
gem "uglifier"
gem "unicorn"
gem "validates_email_format_of"
gem "font-awesome-rails"

# Waiting for 552eb6f7 to be released
gem "rails_admin", github: "sferik/rails_admin"

group :development do
  gem "quiet_assets"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "dotenv-rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.1.0"
end

group :production, :staging do
  gem "font_assets"
  gem "newrelic_rpm", "~> 3.8.1.221"
  gem "rails_12factor"
end

group :test do
  gem "bourne"
  gem "capybara"
  gem "capybara-webkit"
  gem "capybara_discoball", github: "thoughtbot/capybara_discoball"
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
