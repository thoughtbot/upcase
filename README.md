Workshops
========

Workshops is a Rails 3.0 app running on Ruby 1.9.2 and deployed to Heroku. It has an RSpec and Cucumber test suite which should be run before commiting to the master branch.

Laptop setup
------------

Getting the code:

    git clone git@github.com:thoughtbot/workshops.git

Setting up Postgres:

Follow [this tutorial](https://willj.net/2011/05/31/setting-up-postgresql-for-ruby-on-rails-development-on-os-x/)

Setting up Ruby:

    rvm install 1.9.2-p180
    rvm use 1.9.2-p180 --default
    gem install bundler git_remote_branch heroku taps

App:

    cd workshops
    bundle install
    rake db:create:all
    rake db:migrate

Development process
-------------------

    grb create feature-branch
    rake

This creates a new branch for your feature. Name it something relevant. Run the tests to make sure everything's passing. Then, implement the feature.

    rake
    git add -A
    git commit -m "my awesome feature"
    git push origin feature-branch

Open up the Github repo, change into your feature-branch branch. Press the "Pull request" button. It should automatically choose the commits that are different between master and your feature-branch. Create a pull request and share the link in Campfire with the team. When someone else gives you the thumbs-up, you can merge into master:

    git up
    git mm
    git push origin master

For more details and screenshots of the feature branch code review process, read [this blog post](http://robots.thoughtbot.com/post/2831837714/feature-branch-code-reviews).

Staging and production environments
-----------------------------------

We're using Heroku as a hosting provider. Deploying to Heroku is done via git. So, set up your git remotes for each environment:

    git remote add staging git@heroku.com:workshops-staging.git
    git remote add production git@heroku.com:workshops-production.git

Deploying
---------

To deploy to staging:

    rake deploy:staging

To deploy to production:

    rake deploy:production

Heroku
------

To access data on Heroku:

    heroku console --remote staging
    heroku console --remote production

That will drop you into a Rails console for either environment. You can run ActiveRecord queries from there.

To run a rake task on Heroku:

    heroku rake db:migrate --remote staging
    heroku rake db:migrate --remote production

Any rake task can be run with heroku rake ...

To dump staging or production data into your development environment:

    heroku db:pull --remote staging
    heroku db:pull --remote production

You will see progress bars for each db index and table.

This is much more rare for staging, and should typically never be done to production, but you can also push development data to Heroku:

    heroku db:push --remote staging
    heroku db:push --remote production

To check the status of running app servers, background jobs, cron jobs, etc:

    heroku ps --remote staging
    heroku ps --remote production

Working faster
--------------

For rebasing and maintaining a clean history, edit your ~/.gitconfig to include these aliases:

    [alias]
      up = !git fetch origin && git rebase origin/master
      mm = !test `git rev-parse master` = $(git merge-base HEAD master) && git checkout master && git merge HEAD@{1} || echo "Non-fastforward"

For cheap and easy branchse:

    gem install git_remote_branch

Create an admin user
--------------------

    script/dbconsole
    user = User.create!(:email => "cpytel@thoughtbot.com", :password => "test", :password_confirmation => "test", :first_name => "Chad", :last_name => "Pytel")
    user.admin = true
    user.save!

Acceptance and invoices
-----------------------

When you test or do acceptance on staging and create invoices, be sure to void
the invoices in Freshbooks afterwards.  The login information is in the
Technical Information writeboard.
