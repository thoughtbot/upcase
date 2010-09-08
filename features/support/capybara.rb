require 'cucumber/rails/capybara_javascript_emulation'
require 'capybara/envjs'
require 'capybara_envjs_fixes/cucumber_fixes'

Capybara.save_and_open_page_path = 'tmp'
Capybara.javascript_driver = :envjs
