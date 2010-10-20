require 'capybara'
require 'capybara/driver/envjs_driver'

if Object.const_defined? :Cucumber and self.respond_to? :World
  require 'capybara/envjs/cucumber'
end
