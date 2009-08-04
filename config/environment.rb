# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.

  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on.
  config.gem 'RedCloth',
             :lib => 'redcloth',
             :version => '>= 4.2.2'
  config.gem 'mislav-will_paginate',
             :lib => 'will_paginate',
             :source => 'http://gems.github.com',
             :version => '~> 2.3.11'
  config.gem 'thoughtbot-clearance',
             :lib => 'clearance',
             :source => 'http://gems.github.com',
             :version => '>= 0.7.0'
  config.gem 'justinfrench-formtastic',
             :lib => 'formtastic',
             :source => 'http://gems.github.com',
             :version => '~> 0.2.1'
  config.gem 'thoughtbot-paperclip',
             :lib => 'paperclip',
             :source => 'http://gems.github.com',
             :version => '>= 2.3.0'
  config.gem 'rack',
             :version => '>= 1.0.0'
  
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Add the vendor/gems/*/lib directories to the LOAD_PATH
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end

