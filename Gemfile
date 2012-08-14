source :rubygems

gem "rails", "3.2.3"

gem "jquery-rails"
gem "pg"
gem "bourbon", "~> 1.4.0"
gem "flutie"
gem "RedCloth", require: "redcloth"
gem "will_paginate", git: "git://github.com/xspond/will_paginate.git", branch: "rails3-1"
gem "formtastic", "~> 2.2.0"
gem "nokogiri"
gem "clearance", "~> 0.16.1"
gem "paperclip"
gem "aws-s3", :require => "aws/s3"
gem "aws-sdk"
gem "airbrake"
gem "httparty", "0.8.1"
gem "ruby-freshbooks"
gem "high_voltage"
gem "acts_as_list"
gem "dynamic_form"
gem "snogmetrics"
gem "split", require: 'split/dashboard'
gem 'SystemTimer', platform: :ruby_18
gem "rack-rewrite"
gem "rack-ssl-enforcer", "~> 0.2.4"
gem "kissmetrics"
gem "octokit", "1.1.0"
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem "paypal-express", "~> 0.4.6", require: 'paypal'
gem "csv_rails", "~> 0.6.1"
gem 'chameleon'
gem "thin", "~> 1.3.1"
gem "rails_admin"
gem 'typhoeus'
gem "omniauth", "~> 1.1.0"
gem "omniauth-github", "~> 1.0.2"

# Fix the warning: regexp match /.../n against to UTF-8 string issue
gem "escape_utils"

group :development do
  gem 'hirb'
  gem 'tddium'
end

group :development, :test do
  gem "rspec-rails", "~> 2.9.0"
  gem 'ruby-debug19', require: 'ruby-debug', platform: :ruby_19
  gem 'foreman', '~> 0.46.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem "selenium-webdriver", "~> 2.25.0"
  gem "cucumber-rails", "~> 1.1", require: false
  gem 'capybara', "~> 1.1.2"
  gem "factory_girl_rails", "~> 3.3.0"
  gem "launchy"
  gem "database_cleaner"
  gem "sinatra"
  gem "timecop"
  gem "shoulda"
  gem "sham_rack", "1.3.1"
  gem "email_spec", "~> 1.2.1"
  gem "mocha"
  gem "bourne", "~> 1.1.2"
  gem 'vcr', '~> 2.1.1'
  gem 'webmock', '~> 1.8.7'
end

group :staging, :production do
  gem "rack-cache", "~> 1.2"
  gem "dalli", "~> 2.1.0"
end
