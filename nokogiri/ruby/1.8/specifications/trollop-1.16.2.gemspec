# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{trollop}
  s.version = "1.16.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["William Morgan"]
  s.date = %q{2010-04-06}
  s.description = %q{Trollop is a commandline option parser for Ruby that just
gets out of your way. One line of code per option is all you need to write.
For that, you get a nice automatically-generated help page, robust option
parsing, command subcompletion, and sensible defaults for everything you don't
specify.}
  s.email = %q{wmorgan-trollop@masanjin.net}
  s.files = ["lib/trollop.rb", "test/test_trollop.rb", "README.txt", "release-script.txt", "FAQ.txt", "History.txt"]
  s.homepage = %q{http://trollop.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{trollop}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Trollop is a commandline option parser for Ruby that just gets out of your way.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
