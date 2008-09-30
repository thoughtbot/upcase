require 'net/http'

# Plugin for applications to automatically post errors to the Hoptoad of their choice.
module HoptoadNotifier

  IGNORE_DEFAULT = ['ActiveRecord::RecordNotFound',
                    'ActionController::RoutingError',
                    'ActionController::InvalidAuthenticityToken',
                    'CGI::Session::CookieStore::TamperedWithCookie']

  # Some of these don't exist for Rails 1.2.*, so we have to consider that.
  IGNORE_DEFAULT.map!{|e| eval(e) rescue nil }.compact!
  IGNORE_DEFAULT.freeze
  
  class << self
    attr_accessor :host, :port, :secure, :api_key, :filter_params
    attr_reader   :backtrace_filters

    # Takes a block and adds it to the list of backtrace filters. When the filters
    # run, the block will be handed each line of the backtrace and can modify
    # it as necessary. For example, by default a path matching the RAILS_ROOT
    # constant will be transformed into "[RAILS_ROOT]"
    def filter_backtrace &block
      (@backtrace_filters ||= []) << block
    end

    # The port on which your Hoptoad server runs.
    def port
      @port || (secure ? 443 : 80)
    end

    # The host to connect to.
    def host
      @host ||= 'hoptoadapp.com'
    end
    
    # Returns the list of errors that are being ignored. The array can be appended to.
    def ignore
      @ignore ||= (HoptoadNotifier::IGNORE_DEFAULT.dup)
      @ignore.flatten!
      @ignore
    end
    
    # Sets the list of ignored errors to only what is passed in here. This method
    # can be passed a single error or a list of errors.
    def ignore_only=(names)
      @ignore = [names].flatten
    end

    # Returns a list of parameters that should be filtered out of what is sent to Hoptoad.
    # By default, all "password" attributes will have their contents replaced.
    def params_filters
      @params_filters ||= %w(password)
    end
    
    # Call this method to modify defaults in your initializers.
    def configure
      yield self
    end
    
    def protocol #:nodoc:
      secure ? "https" : "http"
    end
    
    def url #:nodoc:
      URI.parse("#{protocol}://#{host}:#{port}/notices/")
    end
    
    def default_notice_options #:nodoc:
      {
        :api_key       => HoptoadNotifier.api_key,
        :error_message => 'Notification',
        :backtrace     => caller,
        :request       => {},
        :session       => {},
        :environment   => ENV.to_hash
      }
    end
    
    # You can send an exception manually using this method, even when you are not in a
    # controller. You can pass an exception or a hash that contains the attributes that
    # would be sent to Hoptoad:
    # * api_key: The API key for this project. The API key is a unique identifier that Hoptoad
    #   uses for identification.
    # * error_message: The error returned by the exception (or the message you want to log).
    # * backtrace: A backtrace, usually obtained with +caller+.
    # * request: The controller's request object.
    # * session: The contents of the user's session.
    # * environment: ENV merged with the contents of the request's environment.
    def notify notice = {}
      Sender.new.notify_hoptoad( notice )
    end
  end

  filter_backtrace do |line|
    line.gsub(/#{RAILS_ROOT}/, "[RAILS_ROOT]")
  end

  filter_backtrace do |line|
    line.gsub(/^\.\//, "")
  end

  filter_backtrace do |line|
    Gem.path.inject(line) do |line, path|
      line.gsub(/#{path}/, "[GEM_ROOT]")
    end
  end

  # Include this module in Controllers in which you want to be notified of errors.
  module Catcher

    def self.included(base) #:nodoc:
      if base.instance_methods.include? 'rescue_action_in_public' and !base.instance_methods.include? 'rescue_action_in_public_without_hoptoad'
        base.alias_method_chain :rescue_action_in_public, :hoptoad
      end
    end
    
    # Overrides the rescue_action method in ActionController::Base, but does not inhibit
    # any custom processing that is defined with Rails 2's exception helpers.
    def rescue_action_in_public_with_hoptoad exception
      notify_hoptoad(exception) unless ignore?(exception)
      rescue_action_in_public_without_hoptoad(exception)
    end 
        
    # This method should be used for sending manual notifications while you are still
    # inside the controller. Otherwise it works like HoptoadNotifier.notify. 
    def notify_hoptoad hash_or_exception
      if public_environment?
        notice = normalize_notice(hash_or_exception)
        clean_notice(notice)
        send_to_hoptoad(:notice => notice)
      end
    end

    alias_method :inform_hoptoad, :notify_hoptoad

    # Returns the default logger or a logger that prints to STDOUT. Necessary for manual
    # notifications outside of controllers.
    def logger
      ActiveRecord::Base.logger
    rescue
      @logger ||= Logger.new(STDERR)
    end

    private
    
    def public_environment? #nodoc:
      defined?(RAILS_ENV) and !['development', 'test'].include?(RAILS_ENV)
    end
    
    def ignore?(exception) #:nodoc:
      ignore_these = HoptoadNotifier.ignore.flatten
      ignore_these.include?(exception.class) || ignore_these.include?(exception.class.name)
    end

    def exception_to_data exception #:nodoc:
      data = {
        :api_key       => HoptoadNotifier.api_key,
        :error_class   => exception.class.name,
        :error_message => "#{exception.class.name}: #{exception.message}",
        :backtrace     => exception.backtrace,
        :environment   => ENV.to_hash
      }

      if self.respond_to? :request
        data[:request] = {
          :params      => request.parameters.to_hash,
          :rails_root  => File.expand_path(RAILS_ROOT),
          :url         => "#{request.protocol}#{request.host}#{request.request_uri}"
        }
        data[:environment].merge!(request.env.to_hash)
      end

      if self.respond_to? :session
        data[:session] = {
          :key         => session.instance_variable_get("@session_id"),
          :data        => session.instance_variable_get("@data")
        }
      end

      data
    end

    def normalize_notice(notice) #:nodoc:
      case notice
      when Hash
        HoptoadNotifier.default_notice_options.merge(notice)
      when Exception
        HoptoadNotifier.default_notice_options.merge(exception_to_data(notice))
      end
    end

    def clean_notice(notice) #:nodoc:
      notice[:backtrace] = clean_hoptoad_backtrace(notice[:backtrace])
      if notice[:request].is_a?(Hash) && notice[:request][:params].is_a?(Hash)
        notice[:request][:params] = clean_hoptoad_params(notice[:request][:params])
      end
    end

    def send_to_hoptoad data #:nodoc:
      url = HoptoadNotifier.url
      Net::HTTP.start(url.host, url.port) do |http|
        headers = {
          'Content-type' => 'application/x-yaml',
          'Accept' => 'text/xml, application/xml'
        }
        http.read_timeout = 5 # seconds
        http.open_timeout = 2 # seconds
        # http.use_ssl = HoptoadNotifier.secure
        response = begin
                     http.post(url.path, stringify_keys(data).to_yaml, headers)
                   rescue TimeoutError => e
                     logger.error "Timeout while contacting the Hoptoad server."
                     nil
                   end
        case response
        when Net::HTTPSuccess then
          logger.info "Hoptoad Success: #{response.class}"
        else
          logger.error "Hoptoad Failure: #{response.class}\n#{response.body if response.respond_to? :body}"
        end
      end
    end
    
    def clean_hoptoad_backtrace backtrace #:nodoc:
      if backtrace.to_a.size == 1
        backtrace = backtrace.to_a.first.split(/\n\s*/)
      end
    
      backtrace.to_a.map do |line|
        HoptoadNotifier.backtrace_filters.inject(line) do |line, proc|
          proc.call(line)
        end
      end
    end
    
    def clean_hoptoad_params params #:nodoc:
      params.each do |k, v|
        params[k] = "<filtered>" if HoptoadNotifier.params_filters.any? do |filter|
          k.to_s.match(/#{filter}/)
        end
      end
    end
    
    def stringify_keys(hash) #:nodoc:
      hash.inject({}) do |h, pair|
        h[pair.first.to_s] = pair.last.is_a?(Hash) ? stringify_keys(pair.last) : pair.last
        h
      end
    end

  end

  # A dummy class for sending notifications manually outside of a controller.
  class Sender
    def rescue_action_in_public(exception)
    end

    include HoptoadNotifier::Catcher
  end
end
