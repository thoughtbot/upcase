class Capybara::Driver::Envjs::Node

  def jquery_trigger(event)
    driver.evaluate_script(<<-END_JS)
      $('##{self['id']}').trigger('#{event}');
    END_JS
  end

  def set_with_events(value)
    case node.getAttribute("type")
    when "checkbox", "radio"
      set_radio(value)
    else
      set_text_input(value)
    end
  end
  alias_method_chain :set, :events

  def set_radio(value)
    set_without_events(value)
    jquery_trigger('change')
  end

  def set_text_input(value)
    jquery_trigger('focus')
    set_without_events(value)
    jquery_trigger('keydown')
    jquery_trigger('keyup')
    jquery_trigger('change')
    jquery_trigger('blur')
  end

  def select_with_events(options)
    select_without_events(options)
    jquery_trigger('change')
  end
  alias_method_chain :select, :events

  # This is overridden because the default implementation only supports nodes
  # hidden by setting the style attribute, which doesn't take into account the
  # computed style
  def visible?
    all_unfiltered("./ancestor-or-self::*").none? do |capybara_node|
      capybara_node.node.style['display'] == 'none'
    end
  end
end

class Capybara::Driver::Envjs
  def initialize(app)
    default_host = @default_host = (Capybara.default_host || "www.example.com")
    @default_url = "http://"+@default_host
    @app_host = (ENV["CAPYBARA_APP_HOST"] || Capybara.app_host || @default_url)

    @rack_test = @app_host == @default_url

    if rack_test?
      require 'rack/test'
      class << self; self; end.instance_eval do
        include ::Rack::Test::Methods
        alias_method :response, :last_response
        alias_method :request, :last_request
        define_method :build_rack_mock_session do
          Rack::MockSession.new(app, default_host)
        end
      end
    end

    @app = app

    master_load = browser.master["load"]

    if rack_test?
      browser.master["load"] = proc do |*args|
        if args.size == 2 and args[1].to_s != "[object split_global]"
          file, window = *args
          body = nil
          if file.index(app_host) == 0
            get(file, {}, env)
            body = response.body
          else
            body = Net::HTTP.get(URI.parse(file))
          end
          window["evaluate"].call body
        else
          master_load.call *args
        end
      end

      browser["window"]["$envx"]["connection"] =
      browser.master["connection"] = @connection = proc do |*args|
        xhr, responseHandler, data = *args
        url = xhr.url
        params = data || {}
        method = xhr["method"].downcase.to_sym

        e = env;
        xhr.headers.each do |k, v|
          next if /^content-type$/i =~ k
          next if /^content-length$/i =~ k
          next if /^cookie$/i =~ k
          e['HTTP_' + k.gsub(/-/o, '_').upcase] = v
        end
        if method == :post or method == :put
          e.merge! "CONTENT_TYPE" => xhr.headers["Content-Type"]
        end
        if e["CONTENT_TYPE"] =~ %r{^multipart/form-data;}
          e["CONTENT_LENGTH"] ||= params.length
        end
        times = 0
        begin
          if url.index(app_host) == 0
            url.slice! 0..(app_host.length-1)
          end
          send method, url, params, e
          while response.status == 302 || response.status == 301
            if (times += 1) > 5
              raise Capybara::InfiniteRedirectError, "redirected more than 5 times, check for infinite redirects."
            end
            params = {}
            method = :get
            url = response.location
            if url.index(app_host) == 0
              url.slice! 0..(app_host.length-1)
            end
            send method, url, params, e
          end
        rescue Exception => e
          # print "got #{e} #{response.inspect}\n"
          raise e
        end
        @source = response.body
        response.headers.each do |k,v|
          xhr.responseHeaders[k] = v
        end
        xhr.status = response.status
        xhr.responseText = response.body
        xhr.readyState = 4
        if url.index(app_host) == 0
          url.slice! 0..(app_host.length-1)
        end
        if url.slice(0..0) == "/"
          url = app_host+url
        end
        xhr.__url = url
        responseHandler.call
      end
    end
  end

  def env
    env = {}
    begin
      @referrer = request.url if last_response.content_type.include?('text/html')
      env["HTTP_REFERER"] = @referrer
    rescue Rack::Test::Error
      # no request yet
    end
    env
  end
end

