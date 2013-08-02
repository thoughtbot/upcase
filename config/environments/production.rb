require Rails.root.join('config/initializers/mail')

Workshops::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Compress JavaScripts and CSS
  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.action_controller.asset_host = "//d3v2mfwlau8x6c.cloudfront.net"
  config.assets.compile = false
  config.assets.compress = true
  config.assets.digest = true
  config.assets.precompile += %w( print.css prefilled_input.js )
  config.serve_static_assets = false

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # Use 'X-Accel-Redirect' for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  HOST = 'learn.thoughtbot.com'
  config.action_mailer.default_url_options = {host: HOST}

  config.middleware.use Rack::SslEnforcer,
                        hsts: false,
                        except: %r{^/podcast},
                        strict: true,
                        redirect_to: "https://#{HOST}"

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = MAIL_SETTINGS
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default(charset: "utf-8")
  config.action_mailer.raise_delivery_errors = true

  PAYPAL_USERNAME = "purchasing_api1.thoughtbot.com"
  PAYPAL_PASSWORD = "NJJDV9RS6Z3PL8LG"
  PAYPAL_SIGNATURE = "AGFLtEG6qkicR9BIyz2VureilJErAQ0TCpd6RiBrrCgcLa2pizcm-NtA"
  PAPERCLIP_STORAGE_OPTIONS = {
     storage: :s3,
     s3_credentials: "#{Rails.root}/config/s3.yml",
     s3_protocol: 'https'
  }

  GITHUB_KEY = ENV['GITHUB_KEY']
  GITHUB_SECRET = ENV['GITHUB_SECRET']

  config.middleware.use Rack::Cache,
    :verbose => true,
    :metastore => "memcached://#{ENV['MEMCACHE_SERVERS']}",
    :entitystore => "memcached://#{ENV['MEMCACHE_SERVERS']}"
end
