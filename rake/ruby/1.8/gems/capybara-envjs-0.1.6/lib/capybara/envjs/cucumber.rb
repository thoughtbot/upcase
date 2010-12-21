require 'capybara/cucumber'
require 'capybara/envjs'

Before('@envjs') do
  Capybara.current_driver = :envjs
end
