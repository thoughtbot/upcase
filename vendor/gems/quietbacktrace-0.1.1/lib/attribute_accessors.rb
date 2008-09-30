# :stopdoc:
#
# Snipped directly from ActiveSupport from Rails 1.2.3
# If Quiet Backtrace is run from a Rails app, the actual ActiveSupport
# methods will be used. That way, mattr_accessor and cattr_accessor will 
# not be overridden in your Rails app if Quiet Backtrace is installed.
#
# Copyright (c) 2005-2006 David Heinemeier Hansson
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# activesupport/lib/activesupport/core_ext/module/attribute_accessors.rb
#
# Extends the module object with module and instance accessors for class attributes, 
# just like the native attr* accessors for instance attributes.
unless defined?(ActiveSupport)
  class Module # :nodoc:
    def mattr_reader(*syms)
      syms.each do |sym|
        next if sym.is_a?(Hash)
        class_eval(<<-EOS, __FILE__, __LINE__)
          unless defined? @@#{sym}
            @@#{sym} = nil
          end
        
          def self.#{sym}
            @@#{sym}
          end

          def #{sym}
            @@#{sym}
          end
        EOS
      end
    end
  
    def mattr_writer(*syms)
      options = syms.last.is_a?(Hash) ? syms.pop : {}
      syms.each do |sym|
        class_eval(<<-EOS, __FILE__, __LINE__)
          unless defined? @@#{sym}
            @@#{sym} = nil
          end
        
          def self.#{sym}=(obj)
            @@#{sym} = obj
          end
        
          #{"
          def #{sym}=(obj)
            @@#{sym} = obj
          end
          " unless options[:instance_writer] == false }
        EOS
      end
    end
  
    def mattr_accessor(*syms)
      mattr_reader(*syms)
      mattr_writer(*syms)
    end
  end

  # activesupport/lib/activesupport/core_ext/class/attribute_accessors.rb

  # Extends the class object with class and instance accessors for class attributes,
  # just like the native attr* accessors for instance attributes.
  class Class # :nodoc:
    def cattr_reader(*syms)
      syms.flatten.each do |sym|
        next if sym.is_a?(Hash)
        class_eval(<<-EOS, __FILE__, __LINE__)
          unless defined? @@#{sym}
            @@#{sym} = nil
          end

          def self.#{sym}
            @@#{sym}
          end

          def #{sym}
            @@#{sym}
          end
        EOS
      end
    end

    def cattr_writer(*syms)
      options = syms.last.is_a?(Hash) ? syms.pop : {}
      syms.flatten.each do |sym|
        class_eval(<<-EOS, __FILE__, __LINE__)
          unless defined? @@#{sym}
            @@#{sym} = nil
          end

          def self.#{sym}=(obj)
            @@#{sym} = obj
          end

          #{"
          def #{sym}=(obj)
            @@#{sym} = obj
          end
          " unless options[:instance_writer] == false }
        EOS
      end
    end

    def cattr_accessor(*syms)
      cattr_reader(*syms)
      cattr_writer(*syms)
    end
  end
end
