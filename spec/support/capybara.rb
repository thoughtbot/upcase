require "selenium/webdriver"

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  config.before(:each, js: true) do
    Capybara.page.driver.browser.manage.window.resize_to(1920, 1080)
  end

  config.before(:each, type: :system, visible_js: true) do
    driven_by :selenium_chrome
  end
end

Capybara.javascript_driver = :selenium_chrome_headless
