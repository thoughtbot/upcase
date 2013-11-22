require 'spec_helper'

describe SubscriptionMailer do
  describe '.welcome_to_prime_from_mentor' do
    it 'is sent to the user' do
      user = build_stubbed(:user, :with_mentor)
      email = SubscriptionMailer.welcome_to_prime_from_mentor(user)
      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
    end

    it 'comes from the mentor' do
      user = build_stubbed(:user, :with_mentor)
      email = SubscriptionMailer.welcome_to_prime_from_mentor(user)

      expect(email.reply_to).to include(user.mentor.email)
    end

    it 'is BCCed to the mentor' do
      user = build_stubbed(:user, :with_mentor)
      email = SubscriptionMailer.welcome_to_prime_from_mentor(user)

      expect(email.bcc).to include user.mentor.email
    end

    it 'mentions mentoring and scheduling a call' do
      user = build_stubbed(:user, :with_mentor)
      email = SubscriptionMailer.welcome_to_prime_from_mentor(user)

      expect(email.body).to include('mentor')
      expect(email.body).to include('calendar')
    end

    it "contains the mentor's availability" do
      user = build_stubbed(:user, :with_mentor)
      user.mentor.availability = 'Never available'
      email = SubscriptionMailer.welcome_to_prime_from_mentor(user)

      expect(email.body).to include('Never available')
    end

    it "contains the mentor's github username" do
      user = build_stubbed(:user, :with_mentor)
      user.mentor.github_username = 'gituser'
      email = SubscriptionMailer.welcome_to_prime_from_mentor(user)

      expect(email.body).to include('gituser')
    end
  end

  describe '.welcome_to_prime' do
    it 'is sent to the user' do
      user = create(:subscription).user
      email = SubscriptionMailer.welcome_to_prime(user)
      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
    end

    it 'comes from Chad' do
      user = create(:subscription, plan: create(:downgraded_plan)).user
      email = SubscriptionMailer.welcome_to_prime(user)

      expect(email.from).to include('chad@thoughtbot.com')
      expect(email.reply_to).to include('learn@thoughtbot.com')
    end

    it 'does not mention mentoring, scheduling a call' do
      user = create(:subscription).user
      email = SubscriptionMailer.welcome_to_prime(user)

      expect(email.subject).to eq 'Welcome to Prime!'
      expect(email.body).not_to include('mentor')
      expect(email.body).not_to include('calendar')
      expect(email.body).to include('workshops')
    end

    it 'does not mention workshops if not included in subscription' do
      user = create(:subscription, plan: create(:downgraded_plan)).user
      email = SubscriptionMailer.welcome_to_prime(user)

      expect(email.body).not_to include('workshops')
    end
  end

  describe '.cancellation_survey' do
    it 'sends a survey to the user who just unsubscribed' do
      user = create(:user)
      email = SubscriptionMailer.cancellation_survey(user)
      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
      expect(email).to have_body_text(/just canceled/)
    end
  end

  describe '.subscription_receipt' do
    include Rails.application.routes.url_helpers

    it 'is sent to the given email' do
      expect(subscription_receipt_email.to).to eq(%w(email@example.com))
    end

    it 'includes the billed amount as currency' do
      expect(subscription_receipt_email).to have_body_text(/\$99.00/)
    end

    it 'includes a link to the invoice' do
      expect(subscription_receipt_email).to have_body_text(subscriber_invoice_url('invoice_id'))
    end

    it 'is sent from learn' do
      expect(subscription_receipt_email.from).to eq(%w(learn@thoughtbot.com))
    end

    def subscription_receipt_email
      SubscriptionMailer.subscription_receipt('email@example.com', 'Prime', 99, 'invoice_id')
    end
  end
end

