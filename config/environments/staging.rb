Workshops::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  config.cache_store = :dalli_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  HOST = 'learn-staging.herokuapp.com'
  config.action_mailer.default_url_options = {host: HOST}

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.default(charset: "utf-8")
  ActionMailer::Base.raise_delivery_errors = true

  Paypal.sandbox = true

  PAYPAL_USERNAME = "dvtest_1274820363_biz_api1.thoughtbot.com"
  PAYPAL_PASSWORD = "1274820375"
  PAYPAL_SIGNATURE = "AVKfPIxQmv1Cx110eaST5hCDDRvIAHcHwza1R3BuWSImSagGLPnBY7v7"
  PAPERCLIP_STORAGE_OPTIONS = {
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/s3.yml",
    s3_permissions: :private,
    path: "downloads/:id/:filename"
  }

  GITHUB_KEY = ENV['GITHUB_KEY']
  GITHUB_SECRET = ENV['GITHUB_SECRET']

  config.middleware.use Rack::Cache,
    :verbose => true,
    :metastore => "memcached://#{ENV['MEMCACHE_SERVERS']}",
    :entitystore => "memcached://#{ENV['MEMCACHE_SERVERS']}"
end
