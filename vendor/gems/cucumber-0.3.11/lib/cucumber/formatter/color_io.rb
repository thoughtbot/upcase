require 'forwardable'

module Cucumber
  module Formatter
    # Adapter to make #puts/#print/#flush work with colours on Windows
    class ColorIO
      extend Forwardable
      def_delegators :@kernel, :puts, :print # win32console colours only work when sent to Kernel
      def_delegators :@stdout, :flush, :tty?, :write

      def initialize
        @kernel = Kernel
        @stdout = STDOUT
      end

      # Ensure using << still gets colours in win32console
      def <<(output)
        print(output)
        self
      end
    end
  end
end
