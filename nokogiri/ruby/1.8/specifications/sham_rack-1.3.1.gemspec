# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sham_rack}
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Williams"]
  s.date = %q{2010-07-11}
  s.description = %q{ShamRack plumbs Net::HTTP directly into Rack, for quick and easy HTTP testing.}
  s.email = %q{mdub@dogbiscuit.org}
  s.files = ["lib/sham_rack/core_ext/net/http.rb", "lib/sham_rack/http.rb", "lib/sham_rack/registry.rb", "lib/sham_rack/stub_web_service.rb", "lib/sham_rack/version.rb", "lib/sham_rack.rb", "README.markdown", "CHANGES.markdown", "spec/sham_rack/stub_web_service_spec.rb", "spec/sham_rack_spec.rb", "spec/spec_helper.rb", "Rakefile", "benchmark/benchmark.rb", "benchmark/hello_app.rb"]
  s.homepage = %q{http://github.com/mdub/sham_rack}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{shamrack}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Net::HTTP-to-Rack plumbing}
  s.test_files = ["spec/sham_rack/stub_web_service_spec.rb", "spec/sham_rack_spec.rb", "spec/spec_helper.rb", "Rakefile", "benchmark/benchmark.rb", "benchmark/hello_app.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
