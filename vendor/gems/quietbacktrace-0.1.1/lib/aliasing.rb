# :stopdoc:
#
# Snipped directly from ActiveSupport from Rails 1.2.3
# If Quiet Backtrace is run from a Rails app, the actual ActiveSupport
# methods will be used. That way, alias_method_chain will not be 
# overridden in your Rails app if Quiet Backtrace is installed.
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

# activesupport/lib/activesupport/core_ext/module/aliasing.rb
unless defined?(ActiveSupport)
  class Module  # :nodoc:
    # Encapsulates the common pattern of:
    #
    #   alias_method :foo_without_feature, :foo
    #   alias_method :foo, :foo_with_feature
    #
    # With this, you simply do:
    #
    #   alias_method_chain :foo, :feature
    #
    # And both aliases are set up for you.
    #
    # Query and bang methods (foo?, foo!) keep the same punctuation:
    #
    #   alias_method_chain :foo?, :feature
    #
    # is equivalent to
    #
    #   alias_method :foo_without_feature?, :foo?
    #   alias_method :foo?, :foo_with_feature?
    #
    # so you can safely chain foo, foo?, and foo! with the same feature.
    def alias_method_chain(target, feature)
      # Strip out punctuation on predicates or bang methods since
      # e.g. target?_without_feature is not a valid method name.
      aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
      yield(aliased_target, punctuation) if block_given?
      alias_method "#{aliased_target}_without_#{feature}#{punctuation}", target
      alias_method target, "#{aliased_target}_with_#{feature}#{punctuation}"
    end

    # Allows you to make aliases for attributes, which includes 
    # getter, setter, and query methods.
    #
    # Example:
    #
    #   class Content < ActiveRecord::Base
    #     # has a title attribute
    #   end
    #
    #   class Email < ActiveRecord::Base
    #     alias_attribute :subject, :title
    #   end
    #
    #   e = Email.find(1)
    #   e.title    # => "Superstars"
    #   e.subject  # => "Superstars"
    #   e.subject? # => true
    #   e.subject = "Megastars"
    #   e.title    # => "Megastars"
    def alias_attribute(new_name, old_name)
      module_eval <<-STR, __FILE__, __LINE__+1
        def #{new_name}; #{old_name}; end
        def #{new_name}?; #{old_name}?; end
        def #{new_name}=(v); self.#{old_name} = v; end
      STR
    end
  end
end
