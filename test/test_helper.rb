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
  class TestController < ActionController::Base
    attr_accessor :request, :response, :params
 
    def initialize
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      
      # TestCase doesn't have context of a current url so cheat a bit
      @params = {}
      send(:initialize_current_url)
    end
  end
end
