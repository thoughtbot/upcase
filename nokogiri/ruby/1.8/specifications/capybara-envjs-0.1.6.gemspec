# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{capybara-envjs}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steven Parkes"]
  s.date = %q{2010-07-05}
  s.description = %q{capybara-envjs is a {Capybara}[http://github.com/jnicklas/capybara] driver for the envjs gem ({GitHub}[http://github.com/smparkes/env-js],
{rubygems.org}[http://rubygems.org/gems/envjs]).
It is similar to Capybara's rack-test driver in that it runs tests against your rack application directly but fully supports javascript in your application.}
  s.email = ["smparkes@smparkes.net"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/capybara/driver/envjs_driver.rb", "lib/capybara/envjs.rb", "lib/capybara/envjs/cucumber.rb", "spec/driver/envjs_driver_spec.rb", "spec/session/envjs_session_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/smparkes/capybara-envjs}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{capybara-envjs}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{capybara-envjs is a {Capybara}[http://github.com/jnicklas/capybara] driver for the envjs gem ({GitHub}[http://github.com/smparkes/env-js], {rubygems.org}[http://rubygems.org/gems/envjs])}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>, [">= 0.3.9"])
      s.add_runtime_dependency(%q<envjs>, [">= 0.3.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0.5.4"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.1"])
    else
      s.add_dependency(%q<capybara>, [">= 0.3.9"])
      s.add_dependency(%q<envjs>, [">= 0.3.7"])
      s.add_dependency(%q<rack-test>, [">= 0.5.4"])
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 2.6.1"])
    end
  else
    s.add_dependency(%q<capybara>, [">= 0.3.9"])
    s.add_dependency(%q<envjs>, [">= 0.3.7"])
    s.add_dependency(%q<rack-test>, [">= 0.5.4"])
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 2.6.1"])
  end
end
