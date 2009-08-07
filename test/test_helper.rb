ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'action_view/test_case'

Mocha::Configuration.warn_when(:stubbing_non_existent_method)
Mocha::Configuration.warn_when(:stubbing_non_public_method)

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

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

class ActionController::TestCase
  include ActionView::Helpers::RecordIdentificationHelper
end
