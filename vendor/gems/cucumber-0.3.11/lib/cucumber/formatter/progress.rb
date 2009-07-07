require 'cucumber/formatter/console'

module Cucumber
  module Formatter
    class Progress < Ast::Visitor
      include Console

      def initialize(step_mother, io, options)
        super(step_mother)
        @io = io
        @options = options
      end

      def visit_features(features)
        super
        @io.puts
        @io.puts
        print_summary(features)
      end

      def visit_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
        progress(status)
        @status = status
      end

      def visit_table_cell_value(value, width, status)
        status ||= @status
        progress(status) unless table_header_cell?(status)
      end

      private

      def print_summary(features)
        print_steps(:pending)
        print_steps(:failed)
        print_stats(features)
        print_snippets(@options)
        print_passing_wip(@options)
      end

      CHARS = {
        :passed    => '.',
        :failed    => 'F',
        :undefined => 'U',
        :pending   => 'P',
        :skipped   => '-'
      }

      def progress(status)
        char = CHARS[status]
        @io.print(format_string(char, status))
        @io.flush
      end
      
      def table_header_cell?(status)
        status == :skipped_param
      end
    end
  end
end
