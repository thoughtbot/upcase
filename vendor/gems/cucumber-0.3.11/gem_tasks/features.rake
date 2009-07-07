$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format progress}
end

Cucumber::Rake::Task.new('pretty') do |t|
  t.cucumber_opts = %w{--format pretty}
end