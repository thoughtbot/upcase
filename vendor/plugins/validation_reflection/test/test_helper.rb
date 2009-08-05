
ENV["RAILS_ENV"] = "test"
RAILS_ROOT = File.join(File.dirname(__FILE__), '../../../..')

$:.unshift File.join(File.dirname(__FILE__), '../lib')
$:.unshift File.join(RAILS_ROOT, 'lib')
$:.unshift File.join(RAILS_ROOT, 'vendor/rails/activerecord/lib')
$:.unshift File.join(RAILS_ROOT, 'vendor/rails/actionpack/lib')
$:.unshift File.join(RAILS_ROOT, 'vendor/rails/activesupport/lib')


require 'test/unit'
require 'logger'
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_controller/assertions'
require 'html/document'

require 'ruby-debug'

RAILS_DEFAULT_LOGGER = Logger.new(STDERR)
### TODO why is this necessary?
ActionController::Base.logger = RAILS_DEFAULT_LOGGER
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
ActiveRecord::Base.colorize_logging = false


def with_log_level(level)
  old_level = RAILS_DEFAULT_LOGGER.level
  RAILS_DEFAULT_LOGGER.level = level
  yield
ensure
  RAILS_DEFAULT_LOGGER.level = old_level
end

