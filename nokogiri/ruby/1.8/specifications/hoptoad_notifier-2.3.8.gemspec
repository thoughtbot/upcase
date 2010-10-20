# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hoptoad_notifier}
  s.version = "2.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["thoughtbot, inc"]
  s.date = %q{2010-09-29}
  s.email = %q{support@hoptoadapp.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["CHANGELOG", "INSTALL", "MIT-LICENSE", "Rakefile", "README.rdoc", "SUPPORTED_RAILS_VERSIONS", "TESTING.rdoc", "generators/hoptoad/hoptoad_generator.rb", "generators/hoptoad/lib/insert_commands.rb", "generators/hoptoad/lib/rake_commands.rb", "generators/hoptoad/templates/capistrano_hook.rb", "generators/hoptoad/templates/hoptoad_notifier_tasks.rake", "generators/hoptoad/templates/initializer.rb", "lib/hoptoad_notifier/backtrace.rb", "lib/hoptoad_notifier/capistrano.rb", "lib/hoptoad_notifier/configuration.rb", "lib/hoptoad_notifier/notice.rb", "lib/hoptoad_notifier/rack.rb", "lib/hoptoad_notifier/rails/action_controller_catcher.rb", "lib/hoptoad_notifier/rails/controller_methods.rb", "lib/hoptoad_notifier/rails/error_lookup.rb", "lib/hoptoad_notifier/rails/javascript_notifier.rb", "lib/hoptoad_notifier/rails.rb", "lib/hoptoad_notifier/rails3_tasks.rb", "lib/hoptoad_notifier/railtie.rb", "lib/hoptoad_notifier/sender.rb", "lib/hoptoad_notifier/tasks.rb", "lib/hoptoad_notifier/version.rb", "lib/hoptoad_notifier.rb", "lib/hoptoad_tasks.rb", "lib/rails/generators/hoptoad/hoptoad_generator.rb", "test/backtrace_test.rb", "test/catcher_test.rb", "test/configuration_test.rb", "test/helper.rb", "test/hoptoad_tasks_test.rb", "test/logger_test.rb", "test/notice_test.rb", "test/notifier_test.rb", "test/rack_test.rb", "test/rails_initializer_test.rb", "test/sender_test.rb", "rails/init.rb", "script/integration_test.rb", "lib/templates/javascript_notifier.erb", "lib/templates/rescue.erb"]
  s.homepage = %q{http://www.hoptoadapp.com}
  s.rdoc_options = ["--line-numbers", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Send your application errors to our hosted service and reclaim your inbox.}
  s.test_files = ["test/backtrace_test.rb", "test/catcher_test.rb", "test/configuration_test.rb", "test/hoptoad_tasks_test.rb", "test/logger_test.rb", "test/notice_test.rb", "test/notifier_test.rb", "test/rack_test.rb", "test/rails_initializer_test.rb", "test/sender_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<actionpack>, [">= 0"])
      s.add_development_dependency(%q<jferris-mocha>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<actionpack>, [">= 0"])
      s.add_dependency(%q<jferris-mocha>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<actionpack>, [">= 0"])
    s.add_dependency(%q<jferris-mocha>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end
