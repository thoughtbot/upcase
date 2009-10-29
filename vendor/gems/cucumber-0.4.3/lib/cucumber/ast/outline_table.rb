module Cucumber
  module Ast
    class OutlineTable < Table #:nodoc:
      def initialize(raw, scenario_outline)
        super(raw)
        @scenario_outline = scenario_outline
        @cells_class = ExampleRow
        create_step_invocations_for_example_rows!(scenario_outline)
      end

      def accept(visitor)
        return if $cucumber_interrupted
        cells_rows.each_with_index do |row, n|
          if(visitor.options[:expand])
            row.accept(visitor)
          else
            visitor.visit_table_row(row)
          end
        end
        nil
      end

      def accept_hook?(hook)
        @scenario_outline.accept_hook?(hook)
      end

      def skip_invoke!
        example_rows.each do |cells|
          cells.skip_invoke!
        end
      end

      def create_step_invocations_for_example_rows!(scenario_outline)
        example_rows.each do |cells|
          cells.create_step_invocations!(scenario_outline)
        end
      end
      
      def example_rows
        cells_rows[1..-1]
      end

      def visit_scenario_name(visitor, row)
        @scenario_outline.visit_scenario_name(visitor, row)
      end

      class ExampleRow < Cells #:nodoc:
        class InvalidForHeaderRowError < NoMethodError
          def initialize(*args)
            super 'This is a header row and cannot pass or fail'
          end
        end
        
        attr_reader :scenario_outline # https://rspec.lighthouseapp.com/projects/16211/tickets/342

        def create_step_invocations!(scenario_outline)
          @scenario_outline = scenario_outline
          @step_invocations = scenario_outline.step_invocations(self)
        end
        
        def skip_invoke!
          @step_invocations.each do |step_invocation|
            step_invocation.skip_invoke!
          end
        end

        def accept(visitor)
          return if $cucumber_interrupted
          visitor.options[:expand] ? accept_expand(visitor) : accept_plain(visitor)
        end

        def accept_plain(visitor)
          if header?
            @cells.each do |cell|
              cell.status = :skipped_param
              visitor.visit_table_cell(cell)
            end
          else
            visitor.step_mother.before_and_after(self) do
              @step_invocations.each do |step_invocation|
                step_invocation.invoke(visitor.step_mother, visitor.options)
                @exception ||= step_invocation.reported_exception
              end

              @cells.each do |cell|
                visitor.visit_table_cell(cell)
              end
              
              visitor.visit_exception(@scenario_exception, :failed) if @scenario_exception
            end
          end
        end

        def accept_expand(visitor)
          if header?
          else
            visitor.step_mother.before_and_after(self) do
              @table.visit_scenario_name(visitor, self)
              @step_invocations.each do |step_invocation|
                step_invocation.invoke(visitor.step_mother, visitor.options)
                @exception ||= step_invocation.reported_exception
                step_invocation.visit_step_result(visitor)
              end
            end
          end
        end

        def accept_hook?(hook)
          @table.accept_hook?(hook)
        end
        
        def exception
          @exception || @scenario_exception
        end
        
        def fail!(exception)
          @scenario_exception = exception
        end
        
        # Returns true if one or more steps failed
        def failed?
          raise InvalidForHeaderRowError if header?
          @step_invocations.failed? || !!@scenario_exception
        end

        # Returns true if all steps passed
        def passed?
          !failed?
        end

        # Returns the status
        def status
          return :failed if @scenario_exception
          @step_invocations.status
        end

        def backtrace_line
          @scenario_outline.backtrace_line(name, line)
        end

        def name
          "| #{@cells.collect{|c| c.value }.join(' | ')} |"
        end
        
        private

        def header?
          index == 0
        end
      end
    end
  end
end
