Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.preview_path = "#{Rails.root}/app/mailer_previews"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not eager load code on boot.
  config.eager_load = false

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.delivery_method = :test

  config.action_view.raise_on_missing_translations = true

  # Add Rack::LiveReload to bottom of middleware stack with default options:
  config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload

  PAPERCLIP_STORAGE_OPTIONS = {
     storage: :s3,
     s3_credentials: "#{Rails.root}/config/s3.yml",
  }

  GITHUB_KEY = ENV['GITHUB_KEY']
  GITHUB_SECRET = ENV['GITHUB_SECRET']
end
