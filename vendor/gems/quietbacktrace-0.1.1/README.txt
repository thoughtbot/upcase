= Quiet Backtrace

Quiet Backtrace suppresses the noise in your Test::Unit backtrace.
It also provides hooks for you to add additional silencers and filters.

== Install

sudo gem install quietbacktrace

== Usage

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

== Rails-specific usage

Install gemsonrails, add it your Rails app, then freeze quietbacktrace:

* gem install gemsonrails
* cd rails-app-folder
* gemsonrails
* rake gems:freeze GEM=quietbacktrace

Quiet Backtrace comes with an excellent Rails-specific silencer and filter.
They must be added (usually in test_helper.rb) because they are not turned on by default:
  class Test::Unit::TestCase
    self.backtrace_silencers << :rails_vendor
    self.backtrace_filters   << :rails_root
  end

Because Quiet Backtrace works by adding attributes onto Test::Unit::TestCase,
you can add and remove silencers and filters at any level in your test suite,
down to the individual test. 

== Resources

* mailing list: http://groups.google.com/group/quiet_backtrace
* project site: http://rubyforge.org/projects/quietbacktrace

== Authors

* Dan Croak (dcroak@thoughtbot.com, http://dancroak.com) 
* James Golick (james@giraffesoft.ca, http://jamesgolick.com) 
* Joe Ferris (jferris@thoughtbot.com)

Special thanks to the Boston.rb group (http://boston.rubygroup.org)
for cultivating this idea at our inaugural hackfest. 

== Requirements

* Test::Unit 
* aliasing.rb and attribute_accessors.rb, which are snipped from ActiveSupport and 
  are included in the gem. They allow quiet_backtrace.rb to use alias_method_chain, 
  cattr_accessor, and mattr_accessor.

== Copyright

Copyright (c) 2007 Dan Croak, thoughtbot, inc., released under the MIT license

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
