
require 'stackdeck'

module StackDeck
  class Context
    class PgProc < Context
      def initialize(conn, function, lineno)
        # This will obviously fail on an overloaded function, returning
        # the source of one arbitrarily-chosen variant.
        src = conn.query('SELECT prosrc FROM pg_proc WHERE proname = ? ORDER BY pronargs DESC LIMIT 1', function)
        src = src.first until String === src

        lines = src.split(/\r?\n/)

        # Apparently, if the first line of the function is empty (doesn't
        # even contain any whitespace), PG doesn't count it when numbering
        # lines. So we join in, by pretending it isn't there.
        lines.shift if lines.first.empty?

        super lines, lineno
      end
    end
  end

  class Frame
    module Postgres
      class Function < Frame
        def initialize(conn, language, function, lineno, clue=nil)
          @db_connection = conn
          @language = language
          super(function, nil, lineno, clue)
        end
        def context
          @context ||= Context::PgProc.new(@db_connection, function, lineno) if @db_connection
        end
        def context?
          !context.nil?
        end
        def language
          @language.gsub(/ function$/, '')
        end
      end

      def self.extract(ex, conn=nil)
        postgres_stack = []
        if ex.internal_query
          postgres_stack << Frame::SQL.from_char(ex.internal_query, ex.internal_position)
        end
        if ex.context
          postgres_stack.concat ex.context.split(/\n/).map {|s| parse(s, conn) }
        end
        if ex.query
          postgres_stack << Frame::SQL.from_char(ex.query, ex.query_position)
        end
      end

      def self.parse(str, conn=nil)
        if str =~ /([^"]+) "(.*)"(?: line (\d+))?(?: (at [^"]+))?$/
          case $1
          when 'SQL statement'
            Frame::SQL.new($2)
          else
            f = $1.empty? ? nil : $1
            self::Function.new(conn, f, $2, $3.to_i, $4)
          end
        end
      end
    end
  end
end

