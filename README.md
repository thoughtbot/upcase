<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Upcase](#upcase)
- [Development](#development)
  - [Rules of the road](#rules-of-the-road)
  - [Setup](#setup)
  - [Protocol](#protocol)
  - [Continuous Integration](#continuous-integration)
  - [Ongoing](#ongoing)
  - [Payment Testing](#payment-testing)
    - [Stripe](#stripe)
  - [Amazon AWS S3](#amazon-aws-s3)
  - [Deployment](#deployment)
  - [Sending email on staging](#sending-email-on-staging)
- [Product Management](#product-management)
- [Admin Access](#admin-access)
- [Credits](#credits)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Upcase

Upcase is a Rails 4 app deployed to Heroku.

# Development

## Rules of the road

This project is now following Sandi Metz's Rules.

You can read a [description of the rules here](http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers).

All new code should follow these rules. If you make changes in a pre-existing
file that violates these rules you should fix the violations as part of
your work.

## Setup

1. Get the code.

        % git clone git@github.com:thoughtbot/upcase.git

2. Setup your environment.

        % bin/setup

3. Follow instructions in .env to configure Stripe.

        % vim .env

4. Start Foreman.

        % foreman start

5. Verify that the app is up and running.

        % open http://localhost:5000/upcase

## Designing In The Browser

We are using `https://github.com/guard/guard-livereload` and
`https://github.com/johnbintz/rack-livereload`. When you save a file, the open
browser will automatically refresh, and you can view your changes.

Run `bundle exec guard` to start the guard server to auto refresh your browser.

## Protocol

1. Look for cards in the **Next Up** list.
2. When you start a card, add yourself and move the card to the **In Progress**
   list.
3. When opening a pull request, move the card to the **Code Review** list and
   ask in Slack for a review.
4. Once the review is complete, merge into master as usual. Wait for CI to
   finish running the build.
5. Once CI is finished running the build, it will deploy to staging. Move the
   card to **On Staging for acceptance** at this time. Comment on the card with
  acceptance instructions. Include a URL to staging. Ask in Slack for
  acceptance.

In order to avoid bottlenecks and confusion:

* Try to only work on one card at a time. Bring all the way from **Next Up** to
  **Verified on staging** as quickly as possible.
* Prioritize reviewing others' work, both during code reviews and acceptance on
  staging.
* Feel free to be persistent when looking for reviews and acceptance.

For more information, check out the [guides] and [Playbook].

[guides]: https://github.com/thoughtbot/guides/tree/master/protocol/rails
[Playbook]: http://playbook.thoughtbot.com/#tasks

## Continuous Integration

CI is hosted with [CircleCI](https://circleci.com/gh/thoughtbot/upcase). The
build is run automatically whenever any branch is updated on Github.

## Ongoing

* Run test suite before committing to the master branch.

        % rake

* Reset development data as needed.

        % rake dev:prime

* Dump production data into your local db. (Note that you need to drop your
  local database first).

        % rake db:drop
        % heroku pg:pull DATABASE_URL upcase_development -r production

* To test that adding/removing GitHub users works, use the GitHub user
  "cpyteltest".

## Payment Testing

### Stripe

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

## Amazon AWS S3

To test integration with AWS S3, set the following environment variables:

    AWS_BUCKET
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY

## Deployment

CircleCI deploys to staging automatically when a build passes on master.

Once your changes have been verified on staging, deploy to production:

    ./bin/deploy production

## Sending email on staging

We override the recipient on staging to be `ENV['EMAIL_RECIPIENTS']` so that no
one else can receive email from the staging server.

We have it set to `learn+staging@thoughtbot.com`, which is a mailing list.
Instead of changing the variable, ask to be put on the mailing list.

To set it:

    heroku config:set EMAIL_RECIPIENTS=gabe@thoughtbot.com,melissa@apprentice.io -r staging

To see what the current recipient is:

    heroku config:get EMAIL_RECIPIENTS -r staging

# Product Management

Check the [Upcase processes] repository for guides on where to find and how to
do common tasks like customer support, content production, related repositories
and trello boards, and others.

[Upcase processes]: https://github.com/thoughtbot/upcase-processes

# Admin Access

1. Register on the [Upcase](https://upcase.com/sign_up) site.

2. Update your user.

        % heroku run console -r production
        % user = User.find_by_email('foo@example.com')
        % user.admin = true
        % user.save!
        % exit

3. Access the [general admin panel](http://upcase.com/admin) or
   the [workshop admin panel](http://upcase.com/admin).

# Testing With User Accounts

`rake dev:prime` will create user accounts that you can test with in
development. The account that is associated with a team, requires
additional configuration to test in your development environment.

You will need the Test Secret and Test Publishable Strip keys. You can get them
from https://manage.stripe.com/account/apikeys. Add them to your `.env` file.

`STRIPE_API_SECRET_KEY=api_secret_key`
`STRIPE_API_PUBLISHABLE_KEY=api_publishable_key`

# Credits

![thoughtbot](http://thoughtbot.com/logo.png)

This application is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

Thank you to all [the contributors](https://github.com/thoughtbot/upcase/contributors)!

The names and logos for Upcase and thoughtbot are registered trademarks of
thoughtbot, inc.

# License

This application is Copyright © 2007 thoughtbot, inc. It is provided to
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
