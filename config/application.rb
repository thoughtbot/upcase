require_relative "boot"

require 'rails/all'

Bundler.require(*Rails.groups)

module Upcase
  class Application < Rails::Application
    config.load_defaults 6.0
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.eager_load_paths += [
      "#{config.root}/lib",
      "#{config.root}/vendor/lib",
    ]

    config.active_job.queue_adapter = :delayed_job

    config.paths['app/views'] << "#{config.root}/app/modules/teams/views"

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true

    config.action_mailer.default_url_options = { host: ENV["APP_DOMAIN"] }
    config.assets.prefix = "/upcase/assets"
  end
end
