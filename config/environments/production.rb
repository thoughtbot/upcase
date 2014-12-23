require Rails.root.join('config/initializers/mail')

Upcase::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_controller.asset_host = ENV.fetch("ASSET_HOST")
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
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new

  config.middleware.use \
    Rack::SslEnforcer,
    hsts: false,
    strict: true,
    redirect_to: "https://#{ENV["APP_DOMAIN"]}"

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = MAIL_SETTINGS
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default(charset: "utf-8")
  config.action_mailer.raise_delivery_errors = true

  PAPERCLIP_STORAGE_OPTIONS = {
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/s3.yml",
    s3_protocol: 'https'
  }

  GITHUB_KEY = ENV['GITHUB_KEY']
  GITHUB_SECRET = ENV['GITHUB_SECRET']

  config.middleware.insert_before Rack::Runtime, Sprockets::Redirect, manifest: Dir["#{Rails.root}/public/assets/manifest-*.json"].first

  config.font_assets.origin = "https://#{ENV["APP_DOMAIN"]}"
end
