# = Quiet Backtrace
# 
# Quiet Backtrace suppresses the noise in your Test::Unit backtrace.
# It also provides hooks for you to add additional silencers and filters.
# 
# == Install
# 
# sudo gem install quietbacktrace
# 
# == Usage
# 
# Quiet Backtrace works by adding new attributes to Test::Unit::TestCase. 
# By default, their values are: 
#   self.quiet_backtrace = true
#   self.backtrace_silencers = [:test_unit, :gem_root, :e1]
#   self.backtrace_filters = [:method_name]
# 
# Silencers remove lines from the backtrace that return true for given conditions.
# Filters modify the output of backtrace lines.
# 
# Override the defaults by adding your own backtrace_silencers:
#   class Test::Unit::TestCase
#     self.backtrace_silencers :shoulda do |line|
#        line.include? 'vendor/plugins/shoulda'
#     end
#   end
# 
# Or your own backtrace_filters:
#   class Test::Unit::TestCase
#     self.backtrace_filters :ruby_path do |line|
#        ruby_file_path = '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8'
#        line.slice!(0..(line =~ ruby_file_path)) if (line =~ ruby_file_path)
#     end
#   end
#
# Turn Quiet Backtrace off anywhere in your test suite by setting the flag to false:
#   Test::Unit::TestCase.quiet_backtrace = false
# 
# == Rails-specific usage
# 
# Install gemsonrails, add it your Rails app, then freeze quietbacktrace:
# 
# * gem install gemsonrails
# * cd rails-app-folder
# * gemsonrails
# * rake gems:freeze GEM=quietbacktrace
# 
# Quiet Backtrace comes with an excellent Rails-specific silencer and filter.
# They must be added (usually in test_helper.rb) because they are not turned on by default:
#   class Test::Unit::TestCase
#     self.backtrace_silencers << :rails_vendor
#     self.backtrace_filters   << :rails_root
#   end
# 
# Because Quiet Backtrace works by adding attributes onto Test::Unit::TestCase,
# you can add and remove silencers and filters at any level in your test suite,
# down to the individual test.
#
# == Resources
# 
# * mailing list: http://groups.google.com/group/quiet_backtrace
# * project site: http://rubyforge.org/projects/quietbacktrace
# 
# == Authors
# 
# * Dan Croak (dcroak@thoughtbot.com, http://dancroak.com) 
# * James Golick (james@giraffesoft.ca, http://jamesgolick.com) 
# * Joe Ferris (jferris@thoughtbot.com)
# 
# Special thanks to the Boston.rb group (http://bostonrb.org)
# for cultivating this idea at our inaugural hackfest. 
# 
# == Requirements
#
# * Test::Unit 
# * aliasing.rb and attribute_accessors.rb, which are snipped from ActiveSupport and 
#   are included in the gem. They allow quiet_backtrace.rb to use alias_method_chain, 
#   cattr_accessor, and mattr_accessor.
#
# == Copyright
#
# Copyright (c) 2007 Dan Croak, thoughtbot, inc., released under the MIT license

require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/attribute_accessors')
require File.expand_path(File.dirname(__FILE__) + '/aliasing')

module QuietBacktrace # :nodoc: all
  module BacktraceFilter
    def self.included(klass)
      klass.class_eval { alias_method_chain :filter_backtrace, :quieting }
    end

    mattr_accessor :silencers, :filters
    self.silencers, self.filters = {}, {}

    def filter_backtrace_with_quieting(backtrace)
      filter_backtrace_without_quieting(backtrace)

      # Rails view backtraces are flattened into one String. Adjust.
      backtrace = backtrace.first.split("\n") if backtrace.size == 1

      if Test::Unit::TestCase.quiet_backtrace
        backtrace.reject! do |line|
          [*Test::Unit::TestCase.backtrace_silencers].any? do |silencer_name|
            QuietBacktrace::BacktraceFilter.silencers[silencer_name].call(line) if silencer_name
          end
        end

        backtrace.each do |line|
          [*Test::Unit::TestCase.backtrace_filters].each do |filter_name|
            QuietBacktrace::BacktraceFilter.filters[filter_name].call(line) if filter_name
          end
        end          
      end
      
      backtrace
    end
  end
  
  module TestCase
    def self.included(klass)
      klass.class_eval do
        cattr_accessor :quiet_backtrace, :backtrace_silencers, :backtrace_filters
        self.backtrace_filters, self.backtrace_silencers = [], []
        
        extend ClassMethods
        
        new_backtrace_silencer(:test_unit) do |line|
          (line.include?("ruby") && line.include?("/test/unit"))
        end
        new_backtrace_silencer(:os_x_ruby) do |line| 
          line.include?('Ruby.framework')
        end
        new_backtrace_silencer(:gem_root) do |line| 
          line =~ /ruby\/gems/i
        end
        new_backtrace_silencer(:e1) do |line| 
          line == "-e:1"
        end
        new_backtrace_silencer(:rails_vendor) do |line| 
          (line.include?("vendor/plugins") || 
            line.include?("vendor/gems") || 
            line.include?("vendor/rails"))
        end
        
        new_backtrace_filter(:method_name) do |line| 
          line.slice!((line =~ /:in /)..line.length) if (line =~ /:in /)
        end
        new_backtrace_filter(:rails_root) do |line| 
          line.sub!("#{RAILS_ROOT}/", '') if (defined?(RAILS_ROOT) && line.include?(RAILS_ROOT))
        end
        
        self.quiet_backtrace = true
        self.backtrace_silencers = [:test_unit, :os_x_ruby, :gem_root, :e1]
        self.backtrace_filters = [:method_name]
      end
    end
      
    module ClassMethods
      def new_backtrace_silencer(symbol, &block)
        QuietBacktrace::BacktraceFilter.silencers[symbol] = block
      end
    
      def new_backtrace_filter(symbol, &block)
        QuietBacktrace::BacktraceFilter.filters[symbol] = block
      end
    end
  end
end

Test::Unit::Util::BacktraceFilter.module_eval { include QuietBacktrace::BacktraceFilter }
Test::Unit::TestCase.class_eval { include QuietBacktrace::TestCase }
