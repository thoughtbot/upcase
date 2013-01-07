# Learn

Learn is a Rails 3 app running on Ruby 1.9 and deployed to Heroku.

## Development

### Setup

1. Install Homebrew packages.

        $ brew install postgres --no-python
        $ brew install redis

2. Follow post-install instructions for loading launch agents.

        $ brew info postgres
        $ brew info redis

3. Install RVM.

        $ \curl -L https://get.rvm.io | bash -s stable --ruby

4. Get the code.

        $ git clone git@github.com:thoughtbot/learn.git

5. Setup your environment.

        $ rake setup
        $ echo "RACK_ENV=development" >> .env

6. Start Foreman.

        $ foreman start

7. Verify that the app is up and running.

        $ open http://localhost:5000

### Ongoing

* Run test suite before committing to the master branch.

        $ rake

* Reset development data as needed.

        $ rake dev:prime

* Dump production data into your local db.

        $ heroku db:pull -r production

* To test that adding/removing GitHub users works, use the GitHub user
  "cpyteltest".

### Tumblr Imports

1. Create `.env` file with `TUMBLR_API_KEY`.

        $ heroku plugins:install git://github.com/ddollar/heroku-config.git
        $ heroku config:pull --overwrite --interactive -r staging

2. Run a task to fetch all articles or only the latest.

        $ foreman run rake fetch:tumblr:all
        $ foreman run rake fetch:tumblr:recent

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
[staging admin panel](http://learn-staging.herokuapp.com/new_admin/purchase).

## Deployment

1. Install the Heroku toolbelt.

        $ brew install heroku-toolbelt

2. Deploy to staging.

        $ rake deploy:staging

3. Deploy to production.

        $ rake deploy:production

4. Manually invalidate the 12 hour index and topics cache (optional).

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

3. Access the [general admin panel](http://learn.thoughtbot.com/new_admin) or
   the [course admin panel](http://learn.thoughtbot.com/admin).
