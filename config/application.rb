require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Upcase
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.eager_load_paths += [
      "#{config.root}/lib"
    ]

    config.action_mailer.default_url_options = {host: ENV["APP_DOMAIN"]}
    config.assets.prefix = "/upcase/assets"
    # config.action_mailer.preview_paths << "#{Rails.root}/lib/mailer_previews"

    # Bypass protection from open redirect attacks
    # in `redirect_back_or_to` and `redirect_to`.
    config.action_controller.raise_on_open_redirects = false
  end
end
