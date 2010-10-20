# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stackdeck}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Draper"]
  s.date = %q{2010-02-08}
  s.description = %q{Manages stack traces across language boundaries.}
  s.email = %q{matthew@trebex.net}
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = [".document", ".gitignore", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "lib/rack/show_stackdeck.rb", "lib/stackdeck.rb", "lib/stackdeck/context.rb", "lib/stackdeck/exception.rb", "lib/stackdeck/file_reader.rb", "lib/stackdeck/frame.rb", "lib/stackdeck/postgres.rb", "test/helper.rb", "test/test_stackdeck.rb"]
  s.homepage = %q{http://github.com/matthewd/stackdeck}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Manages stack traces across language boundaries}
  s.test_files = ["test/helper.rb", "test/test_stackdeck.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
