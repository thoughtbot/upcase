# support multiple ruby version (fat binaries under windows)
begin
  require 'mysql_api'
rescue LoadError
  if RUBY_PLATFORM =~ /mingw|mswin/ then
    RUBY_VERSION =~ /(\d+.\d+)/
    require "#{$1}/mysql_api"
  end
end

# define version string to be used internally for the Gem by Hoe.
class Mysql
  module GemVersion
    VERSION = '2.8.1'
  end
end
