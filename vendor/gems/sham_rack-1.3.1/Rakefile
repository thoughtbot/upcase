require "rubygems"
require "rake"

require "spec/rake/spectask"

task "default" => "spec"

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--colour", "--format", "progress"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end
