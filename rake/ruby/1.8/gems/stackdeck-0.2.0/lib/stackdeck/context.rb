
module StackDeck
  class Context
    CONTEXT = 7
    attr_reader :before_lineno, :before, :line, :after
    def context_ranges(lines, index)
      first_line = [index - CONTEXT, 0].max
      last_line = [index + CONTEXT, lines.size].min

      [first_line...index, (index + 1)..last_line]
    end
    def initialize(lines, lineno)
      if lineno
        index = lineno - 1
        pre_range, post_range = context_ranges(lines, index)
        @before_lineno = pre_range.begin
        @before = lines[pre_range]
        @line = lines[index]
        @after = lines[post_range]
      else
        @line = lines.join("\n")
      end
    end

    class File < Context
      def initialize(filename, lineno)
        super ::File.readlines(filename).map {|l| l.chomp }, lineno
      end
    end
  end
end

