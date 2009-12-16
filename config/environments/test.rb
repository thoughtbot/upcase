# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'factory_girl', 
           :version => '>= 1.2.3'
config.gem 'shoulda', 
           :version => '>= 2.10.2'
config.gem 'timecop',
           :version => '>= 0.3.4'
config.gem 'fakeweb',
           :version => '>= 1.2.6'

# Webrat and dependencies
# NOTE: don't vendor nokogiri - it's a binary Gem
config.gem 'nokogiri',
           :version => '1.3.3',
           :lib     => false
config.gem 'webrat',
           :version => '0.6.0'

# At the bottom due to a loading bug in Rails
config.gem 'jferris-mocha', 
           :version => '0.9.7.20090911190113',
           :source  => 'http://gems.github.com', 
           :lib     => 'mocha'

HOST = 'localhost'

require 'factory_girl'
begin require 'redgreen'; rescue LoadError; end

config.after_initialize do
  Timecop.travel(Time.now)
end
