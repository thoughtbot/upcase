#!/usr/bin/env ruby
require 'rubygems'
require 'johnson/tracemonkey'
require 'envjs/runtime'
 
require 'nanotest'
include Nanotest
 
rt = Johnson::Runtime.new
rt.extend(Envjs::Runtime)
 
rt.evaluate("var foo = 10");
assert { rt.evaluate("foo") == 10 }

rt.evaluate('window.location = "http://example.com"')
assert { 'Example Web Page' == rt.evaluate('window.document.title') }
assert { 'Example Web Page' == rt.evaluate('this.document.title') }
assert { 'Example Web Page' == rt.evaluate('document.title') }
 
rt.evaluate('window.location = "http://montrealrb.org"')
assert { 'Montreal.rb' == rt.evaluate('window.document.title') }
assert { 'Montreal.rb' == rt.evaluate('this.document.title') }

assert { 'Example Web Page' == rt.evaluate('document.title') }
