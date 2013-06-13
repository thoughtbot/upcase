#This prevents caching via the browser
#in testing mode
module ActionController::ConditionalGet
    def expires_in(*args) ; end
end
Workshops::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  config.autoload_paths += [File.expand_path("#{config.root}/spec/support")]

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Do not compress assets
  config.assets.compress = false

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  HOST = 'www.example.com'
  config.action_mailer.default_url_options = { host: HOST }

  config.after_initialize do
    Timecop.travel(Time.now)
  end

  PAYPAL_USERNAME = "username"
  PAYPAL_PASSWORD = "password"
  PAYPAL_SIGNATURE = "signature"
  PAPERCLIP_STORAGE_OPTIONS = {}

  GITHUB_KEY = 'githubkey'
  GITHUB_SECRET = 'githubsecret'

  ENV['AWS_ACCESS_KEY_ID'] = 'xxxxxxxxxxxxxxxxxxxx'
  ENV['AWS_SECRET_ACCESS_KEY'] = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

  class ClearanceBackDoor
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      sign_in_through_the_back_door
      @app.call(@env)
    end

    private

    def sign_in_through_the_back_door
      if user_id = params['as']
        user = User.find(user_id)
        @env[:clearance].sign_in(user)
      end
    end

    def params
      Rack::Utils.parse_query(@env['QUERY_STRING'])
    end
  end

  config.middleware.use ClearanceBackDoor
end
