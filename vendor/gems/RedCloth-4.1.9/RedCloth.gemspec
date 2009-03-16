# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{RedCloth}
  s.version = "4.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Garber"]
  s.date = %q{2009-02-20}
  s.default_executable = %q{redcloth}
  s.description = %q{RedCloth-4.1.9 - Textile parser for Ruby. http://redcloth.org/}
  s.email = %q{redcloth-upwards@rubyforge.org}
  s.executables = ["redcloth"]
  s.extensions = ["ext/redcloth_scan/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "README"]
  s.files = ["bin/redcloth", "CHANGELOG", "COPYING", "ext/mingw-rbconfig.rb", "ext/redcloth_scan/extconf.rb", "ext/redcloth_scan/redcloth.h", "ext/redcloth_scan/redcloth_attributes.c.rl", "ext/redcloth_scan/redcloth_attributes.java.rl", "ext/redcloth_scan/redcloth_attributes.rl", "ext/redcloth_scan/redcloth_common.c.rl", "ext/redcloth_scan/redcloth_common.java.rl", "ext/redcloth_scan/redcloth_common.rl", "ext/redcloth_scan/redcloth_inline.c.rl", "ext/redcloth_scan/redcloth_inline.java.rl", "ext/redcloth_scan/redcloth_inline.rl", "ext/redcloth_scan/redcloth_scan.c.rl", "ext/redcloth_scan/redcloth_scan.java.rl", "ext/redcloth_scan/redcloth_scan.rl", "extras/ragel_profiler.rb", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/formatters/latex_entities.yml", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "Manifest", "Rakefile", "README", "setup.rb", "test/basic.yml", "test/code.yml", "test/definitions.yml", "test/extra_whitespace.yml", "test/filter_html.yml", "test/filter_pba.yml", "test/helper.rb", "test/html.yml", "test/images.yml", "test/instiki.yml", "test/links.yml", "test/lists.yml", "test/poignant.yml", "test/sanitize_html.yml", "test/table.yml", "test/test_custom_tags.rb", "test/test_erb.rb", "test/test_extensions.rb", "test/test_formatters.rb", "test/test_parser.rb", "test/test_restrictions.rb", "test/textism.yml", "test/threshold.yml", "test/validate_fixtures.rb", "RedCloth.gemspec", "ext/redcloth_scan/redcloth_attributes.c", "ext/redcloth_scan/redcloth_inline.c", "ext/redcloth_scan/redcloth_scan.c"]
  s.has_rdoc = true
  s.homepage = %q{http://redcloth.org}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "RedCloth", "--main", "README"]
  s.require_paths = ["lib", "ext", "lib/case_sensitive_require"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{redcloth}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{RedCloth-4.1.9 - Textile parser for Ruby. http://redcloth.org/}
  s.test_files = ["test/test_custom_tags.rb", "test/test_erb.rb", "test/test_extensions.rb", "test/test_formatters.rb", "test/test_parser.rb", "test/test_restrictions.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
