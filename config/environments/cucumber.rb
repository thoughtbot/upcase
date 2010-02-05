# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.

# IMPORTANT: Setting config.cache_classes to false is known to
# break Cucumber's use_transactional_fixtures method.
# For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'factory_girl', 
           :version => '>= 1.2.3'

# Cucumber and dependencies
config.gem 'cucumber-rails',   :lib => false, :version => '>=0.2.4' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber-rails'))
config.gem 'database_cleaner', :lib => false, :version => '>=0.4.3' unless File.directory?(File.join(Rails.root, 'vendor/plugins/database_cleaner'))
config.gem 'webrat',           :lib => false, :version => '>=0.7.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))

config.gem 'polyglot',
           :version => '0.2.9',
           :lib     => false
config.gem 'treetop',
           :version => '1.4.3',
           :lib     => false
config.gem 'term-ansicolor',
           :version => '1.0.4',
           :lib     => false
config.gem 'diff-lcs',
           :version => '1.1.2',
           :lib     => false
config.gem 'builder',
           :version => '2.1.2',
           :lib     => false

# Webrat and dependencies
# NOTE: don't vendor nokogiri - it's a binary Gem
config.gem 'nokogiri',
           :version => '>= 1.4.0',
           :lib     => false

HOST = 'localhost'
