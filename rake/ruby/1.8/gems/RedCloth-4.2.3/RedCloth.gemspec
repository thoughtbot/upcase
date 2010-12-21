# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{RedCloth}
  s.version = "4.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Garber"]
  s.date = %q{2010-03-01}
  s.default_executable = %q{redcloth}
  s.description = %q{RedCloth-4.2.3 - Textile parser for Ruby.
http://redcloth.org/}
  s.email = %q{redcloth-upwards@rubyforge.org}
  s.executables = ["redcloth"]
  s.extensions = ["ext/redcloth_scan/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "README"]
  s.files = ["bin/redcloth", "CHANGELOG", "COPYING", "ext/redcloth_scan/extconf.rb", "ext/redcloth_scan/redcloth.h", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/formatters/latex_entities.yml", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "lib/tasks/pureruby.rake", "Manifest", "Rakefile", "README", "setup.rb", "spec/custom_tags_spec.rb", "spec/differs/inline.rb", "spec/erb_spec.rb", "spec/extension_spec.rb", "spec/fixtures/basic.yml", "spec/fixtures/code.yml", "spec/fixtures/definitions.yml", "spec/fixtures/extra_whitespace.yml", "spec/fixtures/filter_html.yml", "spec/fixtures/filter_pba.yml", "spec/fixtures/html.yml", "spec/fixtures/images.yml", "spec/fixtures/instiki.yml", "spec/fixtures/links.yml", "spec/fixtures/lists.yml", "spec/fixtures/poignant.yml", "spec/fixtures/sanitize_html.yml", "spec/fixtures/table.yml", "spec/fixtures/textism.yml", "spec/fixtures/threshold.yml", "spec/formatters/class_filtered_html_spec.rb", "spec/formatters/filtered_html_spec.rb", "spec/formatters/html_no_breaks_spec.rb", "spec/formatters/html_spec.rb", "spec/formatters/id_filtered_html_spec.rb", "spec/formatters/latex_spec.rb", "spec/formatters/lite_mode_html_spec.rb", "spec/formatters/no_span_caps_html_spec.rb", "spec/formatters/sanitized_html_spec.rb", "spec/formatters/style_filtered_html_spec.rb", "spec/parser_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "RedCloth.gemspec", "ext/redcloth_scan/redcloth_attributes.c", "ext/redcloth_scan/redcloth_inline.c", "ext/redcloth_scan/redcloth_scan.c"]
  s.homepage = %q{http://redcloth.org}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "RedCloth", "--main", "README"]
  s.require_paths = ["lib", "ext", "lib/case_sensitive_require"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{redcloth}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{RedCloth-4.2.3 - Textile parser for Ruby. http://redcloth.org/}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
