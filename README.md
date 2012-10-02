Workshops
========

Workshops is a Rails 3.0 app running on Ruby 1.9.2 and deployed to Heroku. It
has an RSpec and Cucumber test suite which should be run before committing to
the master branch.

Development
-----------

Getting the code:

    git clone git@github.com:thoughtbot/learn.git

Requirements:

* Postgres
* Redis

Getting up and running:
    rake setup

Development data is already pre-seeded however if you wish to reset the data you can use the rake task:

    rake dev:prime

Fetching tumblr posts:

1. Create `.env` file with TUMBLR_API_KEY. 
   This file should include all environment variables like TUMBLR_API_KEY, which is required to retrieve Tumblr blog posts. You can use [Heroku config](https://github.com/ddollar/heroku-config) to get `ENV` variables from Heroku:

    heroku config:pull --app learn-staging

2. Use [foreman](http://ddollar.github.com/foreman/) to run the rake task locally:

    foreman run rake fetch:tumblr:all

You can also fetch only the latest articles with:

    foreman run rake fetch:tumblr:recent

Staging and production environments
-----------------------------------

We're using Heroku as a hosting provider. Deploying to Heroku is done via git.  Remotes are set up in the setup task.  Both production and staging environments are setup.

The content of the index and topics is cached for 12 hours. To manually invalidate the cache, use the following rake task:

    heroku run rake heroku:flush_cache --app learn-staging

Deploying
---------

To deploy to staging:

    rake deploy:staging

To deploy to production:

    rake deploy:production

Heroku
------

To access data on Heroku:

    heroku run console --remote staging
    heroku run console --remote production

That will drop you into a Rails console for either environment. You can run ActiveRecord queries from there.

To run a rake task on Heroku:

    heroku run rake db:migrate --remote staging
    heroku run rake db:migrate --remote production

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

[Sign up](http://learn.thoughtbot.com/sign_up).

Then at the terminal, do this:

    heroku console --app learn-production
    user = User.find_by_email("YOUR_EMAIL_HERE")
    user.admin = true
    user.save!
    exit

Now you can access [the generic admin](http://learn.thoughtbot.com/new_admin) and [the course admin](http://learn.thoughtbot.com/admin).

Testing payments/purchases in browser
-------------------------------------

To test Stripe payments on staging use a fake credit card.

* Testing Visa card number - `4242424242424242`.
* Expiration date may be any date in the future.
* CVC any 3 digits

To test Paypal payments on staging, use your thoughtbot credit card as the paypal process is live and not sandboxed. After making your purchase you may perform a refund through [rails_admin](http://learn-staging.herokuapp.com/new_admin/purchase).

Acceptance and invoices
-----------------------

When you test or do acceptance on staging for workshops and create invoices, be 
sure to void the invoices in Freshbooks afterwards.  The login information is 
in the Technical Information writeboard.

Web hooks
---------

Freshbooks has [web hooks](http://developers.freshbooks.com/webhooks/). We have
the `payment.create` hook in place. It POSTs to `PaymentsController#create`.
