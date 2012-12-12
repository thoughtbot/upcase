desc "Setup project locally for development"
task :setup do
  puts "Bundling"
  `bundle install`

  puts "Setting up git remotes for production and staging"
  `git remote add staging git@heroku.com:learn-staging.git`
  `git remote add production git@heroku.com:learn-production.git`

  puts "Preparing database"
  Rake::Task["db:create:all"].invoke
  Rake::Task["db:schema:load"].invoke
  Rake::Task["db:test:prepare"].invoke
  Rake::Task["dev:prime"].invoke
end
