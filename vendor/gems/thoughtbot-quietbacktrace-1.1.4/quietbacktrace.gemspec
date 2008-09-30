Gem::Specification.new do |s|
  s.name = "quietbacktrace"
  s.version = "1.1.4"
  s.date = "2008-09-11"
  s.email = "dcroak@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/quietbacktrace"
  s.summary     = "Quiet Backtrace suppresses the noise in your Test::Unit backtrace."
  s.description = "Quiet Backtrace suppresses the noise in your Test::Unit backtrace. It also provides hooks for you to add additional silencers and filters."
  s.files = ["README.markdown", "quietbacktrace.gemspec", "lib/quietbacktrace.rb", "lib/aliasing.rb", "lib/attribute_accessors.rb", "MIT-LICENSE"]
  s.authors = ["thoughtbot, inc.", "Dan Croak", "James Golick"]
end