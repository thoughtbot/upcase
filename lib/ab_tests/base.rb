module AbTests
  class Base
    include Split::Helper
    attr_reader :session, :request, :params

    # If you don't pass params then you can't specify which test path 
    # you wish to experience in the URL params.
    def initialize(session, request, params = nil)
      @session = session
      @request = request
      @params = params
    end
    
    def test_name
      self.class.test_name
    end
    alias_method :to_s, :test_name

    def self.test_name
      name.demodulize.underscore
    end

    # Every test must define a #setup method.
    def self.start(*args)
      new(*args).setup
    end

    # Every test must define a #finish method.
    def self.finish(*args)
      new(*args).finish
    end
  end
end
