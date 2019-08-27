require Rails.root.join("config/smtp")

Rails.application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL") }

  config.assets.compile = false
  config.assets.digest = true
  config.assets.js_compressor = :uglifier

  # Fiddling with expires values is kind of pointless as we use hashing to bust
  # caches during redeploys, but it should bump up our google pagespeed
  # ranking.
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600",
  }

  config.exceptions_app = ActionDispatch::PublicExceptions.new(
    Rails.public_path.join("upcase"),
  )

  config.eager_load = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new

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

  config.middleware.insert_before 0,
                                  Rack::Cors,
                                  debug: false,
                                  logger: (-> { Rails.logger }) do

    allow do
      origins 'thoughtbot.com', 'staging.thoughtbot.com'
      resource '/upcase/assets/*', headers: :any, methods: :get
    end
  end
end
