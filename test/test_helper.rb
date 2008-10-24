ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'action_view/test_case'

class Test::Unit::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  self.backtrace_silencers << :rails_vendor
  self.backtrace_filters   << :rails_root

end

class ActionView::TestCase
  # Enable UrlWriter when testing helpers
  include ActionController::UrlWriter
  # Default host for helper tests
  default_url_options[:host] = HOST
end
