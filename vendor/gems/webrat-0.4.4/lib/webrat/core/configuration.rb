require "webrat/core_extensions/deprecate"

module Webrat

  # Configures Webrat. If this is not done, Webrat will be created
  # with all of the default settings.
  def self.configure(configuration = Webrat.configuration)
    yield configuration if block_given?
    @@configuration = configuration
  end

  def self.configuration # :nodoc:
    @@configuration ||= Webrat::Configuration.new
  end

  # Webrat can be configured using the Webrat.configure method. For example:
  #
  #   Webrat.configure do |config|
  #     config.parse_with_nokogiri = false
  #   end
  class Configuration

    # Should XHTML be parsed with Nokogiri? Defaults to true, except on JRuby. When false, Hpricot and REXML are used
    attr_writer :parse_with_nokogiri

    # Webrat's mode, set automatically when requiring webrat/rails, webrat/merb, etc.
    attr_reader :mode # :nodoc:

    # Save and open pages with error status codes (500-599) in a browser? Defualts to true.
    attr_writer :open_error_files

    # Which rails environment should the selenium tests be run in? Defaults to selenium.
    attr_accessor :application_environment
    webrat_deprecate :selenium_environment, :application_environment
    webrat_deprecate :selenium_environment=, :application_environment=

    # Which port is the application running on for selenium testing? Defaults to 3001.
    attr_accessor :application_port
    webrat_deprecate :selenium_port, :application_port
    webrat_deprecate :selenium_port=, :application_port=

    # Which underlying app framework we're testing with selenium
    attr_accessor :application_framework

    # Which server the application is running on for selenium testing? Defaults to localhost
    attr_accessor :application_address

    # Which server Selenium server is running on. Defaults to nil(server starts in webrat process and runs locally)
    attr_accessor :selenium_server_address

    # Which server Selenium port is running on. Defaults to 4444
    attr_accessor :selenium_server_port

    # Set the key that Selenium uses to determine the browser running. Default *firefox
    attr_accessor :selenium_browser_key

    # How many redirects to the same URL should be halted as an infinite redirect
    # loop? Defaults to 10
    attr_accessor :infinite_redirect_limit
    
    def initialize # :nodoc:
      self.open_error_files = true
      self.parse_with_nokogiri = !Webrat.on_java?
      self.application_environment = :test
      self.application_port = 3001
      self.application_address = 'localhost'
      self.application_framework = :rails
      self.selenium_server_port = 4444
      self.infinite_redirect_limit = 10
      self.selenium_browser_key = '*firefox'
    end

    def parse_with_nokogiri? #:nodoc:
      @parse_with_nokogiri ? true : false
    end

    def open_error_files? #:nodoc:
      @open_error_files ? true : false
    end

    # Allows setting of webrat's mode, valid modes are:
    # :rails, :selenium, :rack, :sinatra, :mechanize, :merb
    def mode=(mode)
      @mode = mode.to_sym
      
      # This is a temporary hack to support backwards compatibility
      # with Merb 1.0.8 until it's updated to use the new Webrat.configure
      # syntax
      if @mode == :merb
        require("webrat/merb_session")
      else
        require("webrat/#{mode}")
      end
    end

  end

end
