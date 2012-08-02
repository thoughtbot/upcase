Workshops
========

Workshops is a Rails 3.0 app running on Ruby 1.9.2 and deployed to Heroku. It
has an RSpec and Cucumber test suite which should be run before committing to
the master branch.

Development
-----------

Getting the code:

    git clone git@github.com:thoughtbot/workshops.git

Requirements:

* Postgres
* Redis

Getting up and running:

    cd workshops
    bundle install --binstubs
    rake db:create:all
    rake db:migrate

Development data:

    rake dev:prime

Fetching tumblr posts:

1. Create `.env` file with TUMBLR_API_KEY. 
   This file should include all environment variables like TUMBLR_API_KEY, which is required to retrieve Tumblr blog posts. You can use [Heroku config](https://github.com/ddollar/heroku-config) to get `ENV` variables from Heroku:

    heroku config:pull --app workshops-staging-cedar

2. Use [foreman](http://ddollar.github.com/foreman/) to run the rake task locally:

    foreman run rake fetch:tumblr:all

You can also fetch only the latest articles with:

    foreman run rake fetch:tumblr:recent

Staging and production environments
-----------------------------------

We're using Heroku as a hosting provider. Deploying to Heroku is done via git. So, set up your git remotes for each environment:

    git remote add staging git@heroku.com:workshops-staging-cedar.git
    git remote add production git@heroku.com:workshops-production-cedar.git

The content of the index and topics is cached for 12 hours. To manually invalidate the cache, use the following rake task:

    heroku run rake heroku:flush_cache --app workshops-staging-cedar

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

Getting admin access
--------------------

Sign up [here](http://workshops.thoughtbot.com/sign_up).

Then at the terminal, do this:

    heroku console --app workshops-production
    user = User.find_by_email("YOUR_EMAIL_HERE")
    user.admin = true
    user.save!
    exit

Now you can access http://workshops.thoughtbot.com/admin

Acceptance and invoices
-----------------------

When you test or do acceptance on staging and create invoices, be sure to void
the invoices in Freshbooks afterwards.  The login information is in the
Technical Information writeboard.

Web hooks
---------

Freshbooks has [web hooks](http://developers.freshbooks.com/webhooks/). We have
the `payment.create` hook in place. It POSTs to PaymentsController#create.
