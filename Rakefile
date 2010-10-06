# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'cucumber/rake/task'

require 'tasks/rails'

desc "Run all specs and features"
task :default => [:spec, :cucumber]

namespace :rcov do
  desc "Run features with coverage"
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.rcov = true
    t.rcov_opts = %w(--rails --exclude features\/,osx\/objc,gems\/)
    t.fork = true
  end
end

