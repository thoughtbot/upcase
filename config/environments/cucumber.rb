config.cache_classes = true # This must be true for Cucumber to operate correctly!

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

config.gem 'thoughtbot-factory_girl', 
           :lib => 'factory_girl', 
           :source => 'http://gems.github.com', 
           :version => '>= 1.2.0'

# Cucumber and dependencies
config.gem 'polyglot',
           :version => '0.2.6',
           :lib     => false
config.gem 'treetop',
           :version => '1.2.6',
           :lib     => false
config.gem 'term-ansicolor',
           :version => '1.0.3',
           :lib     => false
config.gem 'diff-lcs',
           :version => '1.1.2',
           :lib     => false
config.gem 'builder',
           :version => '2.1.2',
           :lib     => false
config.gem 'cucumber',
           :version => '0.3.11'

# Webrat and dependencies
# NOTE: don't vendor nokogiri - it's a binary Gem
config.gem 'nokogiri',
           :version => '1.3.2',
           :lib     => false
config.gem 'webrat',
           :version => '0.4.4'

HOST = 'localhost'
