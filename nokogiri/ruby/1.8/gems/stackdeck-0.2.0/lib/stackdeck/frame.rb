
module StackDeck
  def self.boundary; yield; end

  def self.split_list(full_list, short_list)
    short_list = short_list.dup
    upper = full_list.dup
    lower = []
    while !short_list.empty? && upper.last == short_list.pop
      lower << upper.pop
    end
    [upper, lower.reverse]
  end

  def self.apply_boundary!(deck)
    deck.each_with_index do |s, idx|
      # We don't want any more frames if this is a boundary marker,
      # *and* the exception didn't occur really close to said boundary.
      if s.boundary? && idx > 2
        deck.slice! idx, -1
        break
      end
    end
  end

  class Frame
    attr_accessor :function, :filename, :lineno, :clue
    def initialize(function, filename, lineno, clue=nil)
      @function = function
      @filename = filename unless filename && filename.empty?
      @lineno = lineno
      @clue = clue unless clue && clue.empty?
    end
    def context
      @context ||= Context::File.new(filename, lineno) if filename
    end
    def context?
      !filename.nil?
    end
    def same_line?(other)
      other && self.filename == other.filename && self.lineno == other.lineno
    end
    def language; self.class.name.split('::').last; end
    def boundary?; false; end

    def to_s
      if filename
        if function && function != ''
          "#{filename}:#{lineno}:in `#{function}' [#{language}]"
        else
          "#{filename}:#{lineno} [#{language}]"
        end
      else
        if function && function != ''
          "(#{language}):#{lineno}:in `#{function}'"
        else
          "(#{language}):#{lineno}"
        end
      end
    end

    class Ruby < Frame
      def self.parse(str)
        if str =~ /(.*?):(\d+)(:in `(.*)')?/
          new($4, $1, $2.to_i)
        end
      end
      def self.extract(backtrace)
        backtrace.map {|s| StackDeck::Frame::Ruby.parse(s) }
      end

      def boundary?
        filename == __FILE__ && function == 'boundary'
      end
      def to_s
        if function && function != ''
          "#{filename}:#{lineno}:in `#{function}'"
        else
          "#{filename}:#{lineno}"
        end
      end
    end

    class JavaScript < Frame
      def self.parse(str)
        if str =~ /^(.*)@(.*?):(\d+|\?)$/
          function = $1
          filename = $2
          lineno = $3.to_i

          return if filename == '' && function =~ /^(apply|call)\(/
          return if filename == '' && function == '' && lineno == 0
          return if function =~ /^__hidden(_[A-Za-z0-9_]*)?\(/
          filename = filename.squeeze('/')

          function.sub!(/\(.*/, '')

          new(function, filename, lineno)
        end
      end
    end

    class SQL < Frame
      def self.from_char(query, position)
        before = query[0, position.to_i]
        lineno = 1 + before.size - before.gsub(/\n/, '').size
        self.new(query, lineno)
      end

      def initialize(query, lineno=nil, clue=nil)
        @query = query
        super(nil, nil, lineno, clue)
      end
      def context
        @context ||= Context.new(@query.split(/\n/), lineno) if @query
      end
      def context?
        !@query.nil?
      end
    end
  end
end

