source "https://rubygems.org"

ruby "2.1.5"

gem "active_model_serializers", "~> 0.7.0"
gem "acts_as_list"
gem "airbrake"
gem "analytics-ruby", "~> 2.0.0", require: "segment/analytics"
gem "aws-sdk"
gem "bluecloth"
gem "bourbon", "~> 3.2.1"
gem "neat"
gem "clearance", "~> 1.4.2"
gem "coffee-rails"
gem "delayed_job_active_record"
gem "doorkeeper", "1.3.0"
gem "dynamic_form", "~> 1.1.4"
gem "flutie"
gem "formtastic", "~> 2.2.0"
gem "friendly_id", "~> 5.0.4"
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
gem "rack-rewrite", "~> 1.5.0"
gem "rack-ssl-enforcer", "~> 0.2.4"
gem "rails", "4.1.7"
gem "rails_admin", "~> 0.6.2"
gem "recipient_interceptor"
gem "ruby-freshbooks", "~> 0.4.0"
gem "sass-rails", "~> 4.0.4"
gem "sprockets-redirect",
   github: "arunagw/sprockets-redirect",
   branch: "aa-rails4"
gem "stripe"
gem "stripe_event"
gem "uglifier"
gem "unicorn"
gem "validates_email_format_of"

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

group :staging do
  gem "safety_mailer", "~> 0.0.3"
end

group :test do
  gem "bourne"
  gem "capybara"
  gem "capybara-webkit"
  gem "capybara_discoball", github: "thoughtbot/capybara_discoball"
  gem "codeclimate-test-reporter", require: nil
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_girl_rails"
  gem "launchy"
  gem "selenium-webdriver"
  gem "sham_rack"
  gem "shoulda-matchers", require: false
  gem "simplecov", "~> 0.9", require: false
  gem "sinatra"
  gem "timecop"
  gem "webmock"
end
