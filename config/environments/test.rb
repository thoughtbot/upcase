# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  config.autoload_paths += [File.expand_path("#{config.root}/spec/support")]

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
    config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Do not compress assets
  config.assets.compress = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.active_job.queue_adapter = :inline

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :raise

  # Raises error for missing translations.
  config.action_view.raise_on_missing_translations = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Use memory cache to avoid errors when running tests in parallel
  config.cache_store = :memory_store

  config.after_initialize do
    Timecop.travel(Time.current)
  end

  PAPERCLIP_STORAGE_OPTIONS = {}

  GITHUB_KEY = 'githubkey'
  GITHUB_SECRET = 'githubsecret'

  ENV['AWS_ACCESS_KEY_ID'] = 'xxxxxxxxxxxxxxxxxxxx'
  ENV['AWS_SECRET_ACCESS_KEY'] = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

  config.middleware.use Clearance::BackDoor
end
