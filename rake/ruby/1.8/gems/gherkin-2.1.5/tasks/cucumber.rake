begin
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "--profile default"
end
task :cucumber => [:check_dependencies]

namespace :cucumber do
  Cucumber::Rake::Task.new(:rcov, "Run Cucumber using RCov") do |t|
    t.cucumber_opts = "--profile default"
    t.rcov = true
    t.rcov_opts = %w{--exclude spec\/}
  end

  Cucumber::Rake::Task.new(:native_lexer, "Run Native lexer Cucumber features") do |t|
    t.cucumber_opts = "--profile native_lexer"
  end
  task :native_lexer => [:check_dependencies, :clean, :compile]
end

rescue LoadError
  task :cucumber do
    raise "Cucumber not installed"
  end
end
