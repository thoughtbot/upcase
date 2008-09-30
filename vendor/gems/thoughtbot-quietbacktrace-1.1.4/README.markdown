Quiet Backtrace
===============

Quiet Backtrace suppresses the noise in your Test::Unit backtrace.
It also provides hooks for you to add additional silencers and filters.

Install
-------

sudo gem install quietbacktrace

Usage
-----

Quiet Backtrace works by adding new attributes to Test::Unit::TestCase. 
By default, their values are: 

    self.quiet_backtrace = true
    self.backtrace_silencers = [:test_unit, :gem_root, :e1]
    self.backtrace_filters = [:method_name]

Silencers remove lines from the backtrace that return true for given conditions.
Filters modify the output of backtrace lines.

Override the defaults by adding your own backtrace_silencers:

    class Test::Unit::TestCase
  	  self.new_backtrace_silencer :shoulda do |line| 
        line.include? 'vendor/plugins/shoulda'
      end
      self.backtrace_silencers << :shoulda
    end

Or your own backtrace_filters:

    class Test::Unit::TestCase
      self.new_backtrace_filter :ruby_path do |line|
         ruby_file_path = '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8'
         line.slice!(0..(line =~ ruby_file_path)) if (line =~ ruby_file_path)
      end
      self.backtrace_filters << :ruby_path
    end

Turn Quiet Backtrace off anywhere in your test suite by setting the flag to false:

    Test::Unit::TestCase.quiet_backtrace = false

Rails-specific usage
--------------------

Install the gem and add it your Rails app:

* gem install thoughtbot-quietbacktrace --source http://gems.github.com
* cd vendor/gems
* gem unpack quietbacktrace

Quiet Backtrace comes with an excellent Rails-specific silencer and filter.
They must be added (usually in test_helper.rb) because they are not turned on by default:

    class Test::Unit::TestCase
      self.backtrace_silencers << :rails_vendor
      self.backtrace_filters   << :rails_root
    end

Because Quiet Backtrace works by adding attributes onto Test::Unit::TestCase,
you can add and remove silencers and filters at any level in your test suite,
down to the individual test. 

Requirements
------------

* Test::Unit 
* aliasing.rb and attribute_accessors.rb, which are sniped from ActiveSupport and 
  are included in the gem. They allow quietbacktrace.rb to use alias method chain, 
  cattr accessor, and mattr accessor.

Resources
---------

* [mailing list](http://groups.google.com/group/quiet_backtrace)
* [project site](http://rubyforge.org/projects/quietbacktrace)

Authors
-------

* [Dan Croak](http://dancroak.com) 
* [James Golick](http://jamesgolick.com/) 
* [Joe Ferris](jferris@thoughtbot.com)

Special thanks to the [Boston.rb group](http://bostonrb.org)
for cultivating this idea at our inaugural hackfest. 

Copyright (c) Dan Croak, James Golick, Joe Ferris, thoughtbot, inc.
(the MIT license)
