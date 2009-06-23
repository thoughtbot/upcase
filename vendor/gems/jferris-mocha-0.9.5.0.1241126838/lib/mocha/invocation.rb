module Mocha
  class Invocation # :nodoc:
    attr_reader :mock, :method_name, :arguments
    def initialize(mock, method_name, arguments)
      @mock        = mock
      @method_name = method_name
      @arguments   = arguments
    end
  end
end
