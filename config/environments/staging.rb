require Rails.root.join('config/initializers/mail')

Upcase::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_controller.asset_host = "//d1ux3vdjn6k2ct.cloudfront.net"
  config.assets.compile = false
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.assets.precompile += %w( print.css prefilled_input.js )

  # Serve static assets, which allows us to populate the CDN with compressed
  # assets if a client supports them via Heroku::Deflater
  config.serve_static_assets = true

  # Fiddling with expires values is kind of pointless as we use hashing to bust
  # caches during redeploys, but it should bump up our google pagespeed
  # ranking.
  config.static_cache_control = 'public, max-age=31536000'

  config.eager_load = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.log_level = :debug
  config.log_formatter = ::Logger::Formatter.new

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

  config.font_assets.origin = "http://#{ENV["APP_DOMAIN"]}"

  Mail.register_interceptor(
    RecipientInterceptor.new(ENV.fetch("EMAIL_RECIPIENTS"))
  )
end
