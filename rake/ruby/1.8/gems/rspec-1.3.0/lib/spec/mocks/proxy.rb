module Spec
  module Mocks
    class Proxy
      DEFAULT_OPTIONS = {
        :null_object => false,
      }
      
      @@warn_about_expectations_on_nil = true
      
      def self.allow_message_expectations_on_nil
        @@warn_about_expectations_on_nil = false
        
        # ensure nil.rspec_verify is called even if an expectation is not set in the example
        # otherwise the allowance would effect subsequent examples
        $rspec_mocks.add(nil) unless $rspec_mocks.nil?
      end

      def initialize(target, name=nil, options={})
        @target = target
        @name = name
        @error_generator = ErrorGenerator.new target, name, options
        @expectation_ordering = OrderGroup.new @error_generator
        @expectations = []
        @messages_received = []
        @stubs = []
        @proxied_methods = []
        @options = options ? DEFAULT_OPTIONS.dup.merge(options) : DEFAULT_OPTIONS
        @already_proxied_respond_to = false
      end

      def null_object?
        @options[:null_object]
      end
      
      def as_null_object
        @options[:null_object] = true
        @target
      end

      def add_message_expectation(expected_from, sym, opts={}, &block)        
        __add sym
        warn_if_nil_class sym
        @expectations << build_expectation(expected_from, sym, opts, &block)
        @expectations.last
      end

      def build_expectation(expected_from, sym, opts, &block)
        if stub = find_matching_method_stub(sym) 
          stub.build_child(expected_from, block_given?? block : nil, 1, opts)
        else
          MessageExpectation.new(@error_generator, @expectation_ordering, expected_from, sym, block_given? ? block : nil, 1, opts)
        end
      end

      def add_negative_message_expectation(expected_from, sym, &block)
        __add sym
        warn_if_nil_class sym
        @expectations << NegativeMessageExpectation.new(@error_generator, @expectation_ordering, expected_from, sym, block_given? ? block : nil)
        @expectations.last
      end

      def add_stub(expected_from, sym, opts={}, &implementation)
        __add sym
        @stubs.unshift MessageExpectation.new(@error_generator, @expectation_ordering, expected_from, sym, nil, :any, opts, &implementation)
        @stubs.first
      end

      def remove_stub(message)
        message = message.to_sym
        if stub_to_remove = @stubs.detect { |s| s.matches_name?(message) }
          reset_proxied_method(message)
          @stubs.delete(stub_to_remove)
        else
          raise MockExpectationError, "The method `#{message}` was not stubbed or was already unstubbed"
        end
      end
      
      def verify #:nodoc:
        verify_expectations
      ensure
        reset
      end

      def reset
        clear_expectations
        clear_stubs
        reset_proxied_methods
        clear_proxied_methods
        reset_nil_expectations_warning
      end

      def received_message?(sym, *args, &block)
        @messages_received.any? {|array| array == [sym, args, block]}
      end

      def has_negative_expectation?(sym)
        @expectations.any? {|expectation| expectation.negative_expectation_for?(sym)}
      end
      
      def record_message_received(sym, args, block)
        @messages_received << [sym, args, block]
      end

      def message_received(sym, *args, &block)
        expectation = find_matching_expectation(sym, *args)
        stub = find_matching_method_stub(sym, *args)

        if ok_to_invoke_stub?(stub, expectation)
          record_stub(stub, sym, args, &block)
        elsif expectation
          invoke_expectation(expectation, *args, &block)
        elsif expectation = find_almost_matching_expectation(sym, *args)
          record_almost_matching_expectation(expectation, sym, *args, &block)
        else
          @target.__send__ :method_missing, sym, *args, &block
        end
      end

      def record_stub(stub, sym, args, &block)
        almost_matching_expectation(sym, *args) do |e|
          e.advise(args, block)
        end
        stub.invoke(*args, &block)
      end

      def invoke_expectation(expectation, *args, &block)
        expectation.invoke(*args, &block)
      end

      def record_almost_matching_expectation(expectation, sym, *args, &block)
        expectation.advise(args, block)
        unless (null_object? or has_negative_expectation?(sym))
          raise_unexpected_message_args_error(expectation, *args)
        end
      end

      def ok_to_invoke_stub?(stub, expectation)
        stub && (!expectation || expectation.called_max_times?)
      end

      def raise_unexpected_message_args_error(expectation, *args)
        @error_generator.raise_unexpected_message_args_error expectation, *args
      end

      def raise_unexpected_message_error(sym, *args)
        @error_generator.raise_unexpected_message_error sym, *args
      end
      
      def find_matching_method_stub(sym, *args)
        @stubs.find {|stub| stub.matches(sym, args)}
      end
      
    private

      def __add(sym)
        $rspec_mocks.add(@target) unless $rspec_mocks.nil?
        define_expected_method(sym)
      end
      
      def warn_if_nil_class(sym)
        if proxy_for_nil_class? & @@warn_about_expectations_on_nil          
          Kernel.warn("An expectation of :#{sym} was set on nil. Called from #{caller[2]}. Use allow_message_expectations_on_nil to disable warnings.")
        end
      end
      
      def define_expected_method(sym)
        unless @proxied_methods.include?(sym)
          visibility_string = "#{visibility(sym)} :#{sym}"
          if target_responds_to?(sym)
            munged_sym = munge(sym)
            target_metaclass.instance_eval do
              alias_method munged_sym, sym if method_defined?(sym)
            end
            @proxied_methods << sym
          end
          target_metaclass.class_eval(<<-EOF, __FILE__, __LINE__)
            def #{sym}(*args, &block)
              __mock_proxy.message_received :#{sym}, *args, &block
            end
            #{visibility_string}
          EOF
        end
      end

      def target_responds_to?(sym)
        return @target.__send__(munge(:respond_to?),sym) if @already_proxied_respond_to
        return @already_proxied_respond_to = true if sym == :respond_to?
        return @target.respond_to?(sym, true)
      end

      def visibility(sym)
        if Mock === @target
          'public'
        elsif target_metaclass.private_method_defined?(sym)
          'private'
        elsif target_metaclass.protected_method_defined?(sym)
          'protected'
        else
          'public'
        end
      end

      def munge(sym)
        "proxied_by_rspec__#{sym}"
      end

      def clear_expectations
        @expectations.clear
      end

      def clear_stubs
        @stubs.clear
      end

      def clear_proxied_methods
        @proxied_methods.clear
      end

      def target_metaclass
        class << @target; self; end
      end

      def verify_expectations
        @expectations.map {|e| e.verify_messages_received}
      end

      def reset_proxied_methods
        @proxied_methods.map {|sym| reset_proxied_method(sym)}
      end

      def reset_proxied_method(sym)
        munged_sym = munge(sym)
        target_metaclass.instance_eval do
          remove_method sym
          if method_defined?(munged_sym)
            alias_method sym, munged_sym
            remove_method munged_sym
          end
        end
      end
      
      def proxy_for_nil_class?
        @target.nil?
      end
      
      def reset_nil_expectations_warning
        @@warn_about_expectations_on_nil = true if proxy_for_nil_class?
      end

      def find_matching_expectation(sym, *args)
        @expectations.find {|expectation| expectation.matches(sym, args) && !expectation.called_max_times?} || 
        @expectations.find {|expectation| expectation.matches(sym, args)}
      end

      def almost_matching_expectation(sym, *args, &block)
        if e = find_almost_matching_expectation(sym, *args)
          yield e
        end
      end

      def find_almost_matching_expectation(sym, *args)
        @expectations.find {|expectation| expectation.matches_name_but_not_args(sym, args)}
      end
    end
  end
end
