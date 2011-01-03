# encoding: utf-8
require 'gherkin/formatter/colors'
require 'gherkin/formatter/monochrome_format'
require 'gherkin/formatter/argument'
require 'gherkin/formatter/escaping'
require 'gherkin/formatter/model'
require 'gherkin/native'

module Gherkin
  module Formatter
    class PrettyFormatter
      native_impl('gherkin')

      include Colors
      include Escaping

      def initialize(io, monochrome)
        @io = io
        @monochrome = monochrome
        @format = MonochromeFormat.new #@monochrome ? MonochromeFormat.new : AnsiColorFormat.new
      end

      def feature(statement, uri)
        @uri = uri
        print_comments(statement.comments, '')
        print_tags(statement.tags, '')
        @io.puts "#{statement.keyword}: #{statement.name}"
        print_description(statement.description, '  ', false)
      end

      def background(statement)
        @io.puts
        print_comments(statement.comments, '  ')
        @io.puts "  #{statement.keyword}: #{statement.name}#{indented_element_uri!(statement.keyword, statement.name, statement.line)}"
        print_description(statement.description, '    ')
      end

      def scenario(statement)
        @io.puts
        print_comments(statement.comments, '  ')
        print_tags(statement.tags, '  ')
        @io.puts "  #{statement.keyword}: #{statement.name}#{indented_element_uri!(statement.keyword, statement.name, statement.line)}"
        print_description(statement.description, '    ')
      end

      def scenario_outline(statement)
        scenario(statement)
      end

      def examples(statement, examples_rows)
        @io.puts
        print_comments(statement.comments, '    ')
        print_tags(statement.tags, '    ')
        @io.puts "    #{statement.keyword}: #{statement.name}"
        print_description(statement.description, '    ')
        table(examples_rows)
      end

      def step(statement, multiline_arg, result)
        name = Gherkin::Formatter::Argument.format(statement.name, @format, (result ? result.arguments : []))

        step = "#{statement.keyword}#{statement.name}"
        step = self.__send__(result.status, step, @monochrome) if result

        print_comments(statement.comments, '    ')
        @io.puts("    #{step}#{indented_step_location!(result ? result.stepdef_location : nil)}")
        case multiline_arg
        when Model::PyString
          py_string(multiline_arg)
        when Array
          table(multiline_arg)
        when NilClass
        else
          raise "Bad multiline_arg: #{multiline_arg.inspect}"
        end
      end

      def eof
        # NO-OP
      end

      # This method can be invoked before a #scenario, to ensure location arguments are aligned
      def steps(steps)
        @step_lengths = steps.map {|keyword, name| (keyword+name).unpack("U*").length}
        @max_step_length = @step_lengths.max
        @step_index = -1
      end

      def table(rows)
        cell_lengths = rows.map do |row| 
          row.cells.map do |cell| 
            escape_cell(cell).unpack("U*").length
          end
        end
        max_lengths = cell_lengths.transpose.map { |col_lengths| col_lengths.max }.flatten

        rows.each_with_index do |row, i|
          row.comments.each do |comment|
            @io.puts "      #{comment.value}"
          end
          j = -1
          @io.puts '      | ' + row.cells.zip(max_lengths).map { |cell, max_length|
            j += 1
            color(cell, nil, j) + ' ' * (max_length - cell_lengths[i][j])
          }.join(' | ') + ' |'
        end
      end

    private

      def py_string(py_string)
        @io.puts "      \"\"\"\n" + escape_triple_quotes(indent(py_string.value, '      ')) + "\n      \"\"\""
      end

      def exception(exception)
        exception_text = "#{exception.message} (#{exception.class})\n#{(exception.backtrace || []).join("\n")}".gsub(/^/, '      ')
        @io.puts(failed(exception_text, @monochrome))
      end

      def color(cell, statuses, col)
        if statuses
          self.__send__(statuses[col], escape_cell(cell), @monochrome) + (@monochrome ? '' : reset)
        else
          escape_cell(cell)
        end
      end

      if(RUBY_VERSION =~ /^1\.9/)
        START = /#{'^'.encode('UTF-8')}/
        TRIPLE_QUOTES = /#{'"""'.encode('UTF-8')}/
      else
        START = /^/
        TRIPLE_QUOTES = /"""/
      end

      def indent(string, indentation)
        string.gsub(START, indentation)
      end

      def escape_triple_quotes(s)
        s.gsub(TRIPLE_QUOTES, '\"\"\"')
      end

      def print_tags(tags, indent)
        @io.write(tags.empty? ? '' : indent + tags.map{|tag| tag.name}.join(' ') + "\n")
      end

      def print_comments(comments, indent)
        @io.write(comments.empty? ? '' : indent + comments.map{|comment| comment.value}.join("\n#{indent}") + "\n")
      end

      def print_description(description, indent, newline=true)
        if description != ""
          @io.puts indent(description, indent)
          @io.puts if newline
        end
      end

      def indented_element_uri!(keyword, name, line)
        return '' if @max_step_length.nil?
        l = (keyword+name).unpack("U*").length
        @max_step_length = [@max_step_length, l].max
        indent = @max_step_length - l
        ' ' * indent + ' ' + comments("# #{@uri}:#{line}", @monochrome)
      end

      def indented_step_location!(location)
        return '' if location.nil?
        indent = @max_step_length - @step_lengths[@step_index+=1]
        ' ' * indent + ' ' + comments("# #{location}", @monochrome)
      end
    end
  end
end