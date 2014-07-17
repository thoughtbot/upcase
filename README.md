# Learn

Learn is a Rails 4 app running on Ruby 2.1 and deployed to Heroku.

## Development

### Rules of the road

This project is now following Sandi Metz's Rules.

You can read a [description of the rules here](http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers).

All new code should follow these rules. If you make changes in a pre-existing
file that violates these rules you should fix the violations as part of
your work.

### Setup

1. Install Homebrew packages.

        $ brew install postgres --no-python

2. Follow post-install instructions for loading launch agents.

        $ brew info postgres

3. Install RVM.

        $ \curl -L https://get.rvm.io | bash -s stable --ruby

4. Get the code.

        $ git clone git@github.com:thoughtbot/learn.git

5. Setup your environment.

        $ bin/setup

6. Follow instructions in .env to configure Stripe.

        $ vim .env

7. Start Foreman.

        $ foreman start

8. Verify that the app is up and running.

        $ open http://localhost:5000

### Testing

You'll need to install phantom.js to run some of the specs.

        brew install phantomjs

Also, you may want to use the [spring gem](https://github.com/jonleighton/spring)
to speed up the boot time of your specs. The rspec, rake, and rails binstubs
have been updated to take advantage of spring if it's found.

### Continuous Integration

CI is hosted with Travis. Commits pushed to feature branches are not run
automatically, until a pull request is made to master.

### Ongoing

* Run test suite before committing to the master branch.

        $ rake

* Reset development data as needed.

        $ rake dev:prime

* Dump production data into your local db. (Note that you need to drop your
  local database first).

        $ rake db:drop
        $ heroku pg:pull DATABASE_URL workshops_development -r production

* To test that adding/removing GitHub users works, use the GitHub user
  "cpyteltest".

### Payment Testing

#### Stripe

To test Stripe payments on staging use a fake credit card.

<table>
  <thead>
    <tr>
      <th>Card</th>
      <th>Number</th>
      <th>Expiration</th>
      <th>CVV</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Visa</td>
      <td>4242424242424242</td>
      <td>Any future date</td>
      <td>Any 3 digits</td>
    </tr>
  </tbody>
</table>

#### PayPal

To test PayPal payments on staging, use your thoughtbot credit card as the
paypal process is live and not sandboxed. After making your purchase you may
perform a refund through the
[staging admin panel](http://learn-staging.herokuapp.com/admin/purchase).


## Amazon AWS S3

To test integration with AWS S3, set the following environment variables:

    AWS_BUCKET
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY

## Deployment

1. Install the Heroku toolbelt.

        $ brew install heroku-toolbelt

2. Deploy to staging.

        $ rake deploy:staging

3. Deploy to production.

        $ rake deploy:production

4. Manually invalidate the 12 hour index and topics/videos cache (optional).

        $ heroku run rake heroku:flush_cache -r staging
        $ heroku run rake heroku:flush_cache -r production

5. Check the status of running web and background processes.

        $ heroku ps -r staging
        $ heroku ps -r production

## Sending email on staging

We override the recipient on staging to be `ENV['EMAIL_RECIPIENTS']` so that no
one else can receive email from the staging server.

We have it set to `learn+staging@thoughtbot.com`, which is a mailing list.
Instead of changing the variable, ask to be put on the mailing list.

To set it:

    heroku config:set EMAIL_RECIPIENTS=gabe@thoughtbot.com,melissa@apprentice.io -r staging

To see what the current recipient is:

    heroku config:get EMAIL_RECIPIENTS -r staging

## Admin Access

1. Register on the [Learn](http://learn.thoughtbot.com/sign_up) site.

2. Update your user.

        $ heroku run console -r production
        $ user = User.find_by_email('foo@example.com')
        $ user.admin = true
        $ user.save!
        $ exit

3. Access the [general admin panel](http://learn.thoughtbot.com/admin) or
   the [workshop admin panel](http://learn.thoughtbot.com/admin).

Credits
-------

![thoughtbot](http://thoughtbot.com/logo.png)

This application is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

Thank you to all [the contributors](https://github.com/thoughtbot/paperclip/contributors)!

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

This application is Copyright © 2007 thoughtbot, inc. It is provided to Learn
subscribers for educational purposes only, and Subscribers do not have a license
to reuse or distribute the application or its source code.

If you submit a Contribution to this application's source code, you hereby grant
to thoughtbot, inc. a worldwide, royalty-free, exclusive, perpetual and
irrevocable license, with the right to grant or transfer an unlimited number of
non-exclusive licenses or sublicenses to third parties, under the Copyright
covering the Contribution to use the Contribution by all means, including but
not limited to:

* to publish the Contribution,
* to modify the Contribution, to prepare Derivative Works based upon or
  containing the Contribution and to combine the Contribution with other
  software code,
* to reproduce the Contribution in original or modified form,
* to distribute, to make the Contribution available to the public, display and
  publicly perform the Contribution in original or modified form.
