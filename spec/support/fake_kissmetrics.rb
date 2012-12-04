puts "FakeKissmetrics"
class FakeKissmetrics
  def self.events_for(email)
    instance.events_for(email)
  end

  def self.alias_for(old_email)
    instance.alias_for(old_email)
  end

  def self.properties_for(email, event_name)
    instance.properties_for(email, event_name)
  end

  def self.instance
    @instance ||= FakeKissmetrics::HttpServer.new
  end

  def self.reset
    @instance = nil
  end

  class HttpClient
    def initialize(api_key)
    end

    def record(identity, event_name, properties = {})
      FakeKissmetrics.instance.record(identity, event_name, properties)
    end

    def alias(old_identity, new_identity)
      FakeKissmetrics.instance.alias(old_identity, new_identity)
    end
  end

  class HttpServer
    def initialize
      @events  = {}
      @aliases = {}
    end

    def events_for(email)
      if @events.key?(email)
        @events[email].keys
      else
        []
      end
    end

    def properties_for(email, event_name)
      if @events.key?(email) && @events[email].key?(event_name)
        @events[email][event_name]
      else
        []
      end
    end

    def alias_for(old_email)
      @aliases[old_email]
    end

    def record(identity, event_name, properties)
      @events[identity] ||= {}
      @events[identity][event_name] ||= []
      @events[identity][event_name] << properties
    end

    def alias(old_email, new_email)
      @aliases[old_email] = new_email
    end
  end
end

ApplicationController.km_http_client = FakeKissmetrics::HttpClient
