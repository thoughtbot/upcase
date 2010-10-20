module ShamRack

  module Registry
  
    def mount(rack_app, address, port = nil)
      port ||= Net::HTTP.default_port
      registry[[address, port]] = rack_app
    end
    
    def unmount_all
      registry.clear
    end

    def at(address, port = nil, &block)
      if block
        mount(block, address, port)
      else
        Registrar.new(address, port)
      end
    end
    
    def application_for(address, port = nil)
      port ||= Net::HTTP.default_port
      registry[[address, port]]
    end

    private
    
    def registry
      @registry ||= {}
    end
    
  end
    
  extend Registry

  class Registrar
    
    def initialize(address, port = nil)
      @address = address
      @port = port
    end

    def rackup(&block)
      require "rack"
      app = Rack::Builder.new(&block).to_app
      ShamRack.mount(app, @address, @port)
    end
    
    def sinatra(&block)
      require "sinatra/base"
      sinatra_app = Class.new(Sinatra::Base)
      sinatra_app.class_eval(&block)
      ShamRack.mount(sinatra_app.new, @address, @port)
    end

    def stub
      require "sham_rack/stub_web_service"
      ShamRack.mount(StubWebService.new, @address, @port)
    end
    
  end

end
