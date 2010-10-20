# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{selenium-webdriver}
  s.version = "0.0.28"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jari Bakken"]
  s.date = %q{2010-08-22}
  s.description = %q{WebDriver is a tool for writing automated tests of websites. It aims to mimic the behaviour of a real user, and as such interacts with the HTML of the application.}
  s.email = %q{jari.bakken@gmail.com}
  s.files = ["lib/selenium-webdriver.rb", "lib/selenium/webdriver.rb", "lib/selenium/webdriver/bridge_helper.rb", "lib/selenium/webdriver/child_process.rb", "lib/selenium/webdriver/chrome.rb", "lib/selenium/webdriver/driver.rb", "lib/selenium/webdriver/element.rb", "lib/selenium/webdriver/error.rb", "lib/selenium/webdriver/file_reaper.rb", "lib/selenium/webdriver/find.rb", "lib/selenium/webdriver/firefox.rb", "lib/selenium/webdriver/ie.rb", "lib/selenium/webdriver/keys.rb", "lib/selenium/webdriver/navigation.rb", "lib/selenium/webdriver/options.rb", "lib/selenium/webdriver/platform.rb", "lib/selenium/webdriver/remote.rb", "lib/selenium/webdriver/target_locator.rb", "lib/selenium/webdriver/timeouts.rb", "lib/selenium/webdriver/zip_helper.rb", "lib/selenium/webdriver/chrome/bridge.rb", "lib/selenium/webdriver/chrome/command_executor.rb", "lib/selenium/webdriver/chrome/extension.zip", "lib/selenium/webdriver/chrome/launcher.rb", "lib/selenium/webdriver/core_ext/dir.rb", "lib/selenium/webdriver/core_ext/string.rb", "lib/selenium/webdriver/driver_extensions/takes_screenshot.rb", "lib/selenium/webdriver/firefox/binary.rb", "lib/selenium/webdriver/firefox/bridge.rb", "lib/selenium/webdriver/firefox/launcher.rb", "lib/selenium/webdriver/firefox/profile.rb", "lib/selenium/webdriver/firefox/profiles_ini.rb", "lib/selenium/webdriver/firefox/util.rb", "lib/selenium/webdriver/firefox/extension/webdriver.xpi", "lib/selenium/webdriver/firefox/native/linux/amd64/x_ignore_nofocus.so", "lib/selenium/webdriver/firefox/native/linux/x86/x_ignore_nofocus.so", "lib/selenium/webdriver/ie/bridge.rb", "lib/selenium/webdriver/ie/lib.rb", "lib/selenium/webdriver/ie/util.rb", "lib/selenium/webdriver/ie/native/win32/InternetExplorerDriver.dll", "lib/selenium/webdriver/ie/native/x64/InternetExplorerDriver.dll", "lib/selenium/webdriver/remote/bridge.rb", "lib/selenium/webdriver/remote/capabilities.rb", "lib/selenium/webdriver/remote/commands.rb", "lib/selenium/webdriver/remote/response.rb", "lib/selenium/webdriver/remote/server_error.rb", "lib/selenium/webdriver/remote/http/common.rb", "lib/selenium/webdriver/remote/http/curb.rb", "lib/selenium/webdriver/remote/http/default.rb", "CHANGES", "README"]
  s.homepage = %q{http://selenium.googlecode.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{The next generation developer focused tool for automated testing of webapps}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 0"])
      s.add_runtime_dependency(%q<ffi>, [">= 0.6.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<rubyzip>, [">= 0"])
      s.add_dependency(%q<ffi>, [">= 0.6.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<rubyzip>, [">= 0"])
    s.add_dependency(%q<ffi>, [">= 0.6.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
