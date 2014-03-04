require Rails.root.join('config/initializers/mail')

Workshops::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_controller.asset_host = "//d3v2mfwlau8x6c.cloudfront.net"
  config.assets.compile = false
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.assets.precompile += %w( print.css prefilled_input.js )

  # Serve static assets, which allows us to populate the CDN with compressed
  # assets if a client supports them
  config.serve_static_assets = true

  # Fiddling with expires values is kind of pointless as we use hashing to bust
  # caches during redeploys, but it should bump up our google pagespeed
  # ranking.
  config.static_cache_control = 'public, max-age=31536000'

  config.eager_load = true
  config.cache_store = :dalli_store
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new

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

  PAYPAL_USERNAME = ENV['PAYPAL_USERNAME']
  PAYPAL_PASSWORD = ENV['PAYPAL_PASSWORD']
  PAYPAL_SIGNATURE = ENV['PAYPAL_SIGNATURE']

  PAPERCLIP_STORAGE_OPTIONS = {
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/s3.yml",
    s3_protocol: 'https'
  }

  GITHUB_KEY = ENV['GITHUB_KEY']
  GITHUB_SECRET = ENV['GITHUB_SECRET']

  config.middleware.use Rack::Cache,
    verbose: true,
    metastore: "memcached://#{ENV['MEMCACHE_SERVERS']}",
    entitystore: "memcached://#{ENV['MEMCACHE_SERVERS']}"

  config.middleware.insert_before Rack::Runtime, Sprockets::Redirect, manifest: Dir["#{Rails.root}/public/assets/manifest-*.json"].first
end
