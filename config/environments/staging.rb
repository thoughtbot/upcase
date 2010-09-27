# Settings specified here will take precedence over those in config/environment.rb

# We'd like to stay as close to prod as possible
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Disable delivery errors if you bad email addresses should just be ignored
config.action_mailer.raise_delivery_errors = false

HOST = 'training.thoughtbot.com'
config.action_mailer.default_url_options = {:host => HOST}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_charset = "utf-8"

ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  :address         => 'smtp.gmail.com',
  :domain => "thoughtbot.com",

  :enable_starttls_auto => true,
  :port            => 587,
  :tls             => true,
  :authentication  => :plain,
  :user_name => "donotreply@thoughtbot.com",
  :password => "4e7LRALZ"
}

