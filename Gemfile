source 'https://rubygems.org'

ruby '1.9.3'

gem 'RedCloth', '4.2.9', require: 'redcloth'
gem 'active_model_serializers', '~> 0.7.0'
gem 'acts_as_list', '0.1.6'
gem 'airbrake', '3.0.9'
gem 'aws-s3', '0.6.2', :require => 'aws/s3'
gem 'aws-sdk', '~> 1.10.0'
gem 'bluecloth'
gem 'bourbon', '3.1.6'
gem 'chameleon', '0.2.2'
gem 'clearance', '0.16.1'
gem 'csv_rails', '0.6.1'
gem 'curb', '0.8.1'
gem 'delayed_job_active_record', '0.3.3'
gem 'doorkeeper', '~> 0.6.7'
gem 'dynamic_form', '1.1.4'
gem 'escape_utils', '0.2.4' # Fix UTF-8 regexp match warning
gem 'flutie', '1.3.3'
gem 'formtastic', '2.2.0'
gem 'high_voltage', '1.2.0'
gem 'httparty', '0.8.1'
gem 'jquery-rails'
gem 'json', '~> 1.7.7'
gem 'kissmetrics', '2.0.0'
gem 'nokogiri', '1.5.2'
gem 'octokit', '~> 1.24.0'
gem 'omniauth', '~> 1.1.0'
gem 'omniauth-github', '1.0.2'
gem 'paperclip', '3.0.2'
gem 'paypal-express', '0.4.6', require: 'paypal'
gem 'pg', '0.13.2'
gem 'rack-rewrite', '1.2.1'
gem 'rack-ssl-enforcer', '0.2.4'
gem 'rails', '3.2.13'
gem 'rails_admin'
gem 'ruby-freshbooks', '0.4.0'
gem 'sass', '3.2.1'
gem 'snogmetrics', '0.1.9'
gem 'split', '0.4.1', require: 'split/dashboard'
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'stripe_event'
gem 'thin', '1.3.1'
gem 'typhoeus', '0.3.3'
gem 'to_js', git: 'git://github.com/cpytel/to_js.git'
gem 'validates_email_format_of', '1.5.3'
gem 'mp3info'
gem 'gibbon'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.5'
  gem 'coffee-rails'
  gem 'uglifier', '1.2.4'
end

group :development do
  gem 'hirb', '0.6.2'
end

group :development, :test do
  gem 'foreman', '0.46.0'
  gem 'rspec-rails'
  gem 'debugger'
  gem 'pry-rails'
end

group :production, :staging do
  gem 'memcachier'
  gem 'dalli', '2.1.0'
  gem 'newrelic_rpm'
  gem 'rack-cache', '1.2'
end

group :staging do
  gem 'safety_mailer', '0.0.3'
end

group :test do
  gem 'bourne'
  gem 'capybara', '1.1.2'
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'database_cleaner', '0.7.2'
  gem 'email_spec', '1.2.1'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'poltergeist'
  gem 'selenium-webdriver', '2.32.1'
  gem 'sham_rack', '1.3.1'
  gem 'shoulda-matchers'
  gem 'sinatra', '1.2.8'
  gem 'timecop', '0.3.5'
  gem 'vcr', '2.1.1'
  gem 'webmock', '1.8.7'
  gem 'capybara_discoball',
    :git => 'git@github.com:thoughtbot/capybara_discoball.git'
end
