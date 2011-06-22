task :deploy => "deploy:staging"

namespace :deploy do
  desc "Deploy to Heroku staging"
  task :staging => ["heroku:dependencies"] do
    `git push staging master`
    `bundle exec heroku rake db:migrate --remote staging`
  end

  desc "Deploy to Heroku production"
  task :production => ["heroku:dependencies"] do
    `git push production master`
    `bundle exec heroku rake db:migrate --remote production`
  end
end

namespace :heroku do
  task :dependencies do
    `heroku`
    unless $?.success?
      puts "Heroku gem is not installed.  Try: gem install heroku"
      exit 1
    end

    `cd #{Rails.root} && ls .git/config`
    unless $?.success?
      puts "This doesn't appear to be a git repo.  Try: git init"
      exit 1
    end
  end
end
