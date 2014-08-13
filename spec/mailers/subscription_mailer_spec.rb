require "rails_helper"

describe SubscriptionMailer do
  describe '.welcome_to_prime_from_mentor' do
    it 'is sent to the user' do
      user = user_with_mentor
      email = welcome_email_for(user)

      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
    end

    it 'comes from the mentor' do
      user = user_with_mentor
      email = welcome_email_for(user)

      expect(email.reply_to).to include(user.mentor_email)
    end

    it 'BCCs the mentor' do
      user = user_with_mentor
      email = welcome_email_for(user)

      expect(email.bcc).to include user.mentor_email
    end

    it 'mentions mentoring and scheduling a call' do
      user = user_with_mentor
      email = welcome_email_for(user)

      expect(email.body).to include('mentor')
      expect(email.body).to include('calendar')
    end

    it "contains the mentor's availability" do
      user = user_with_mentor
      user.mentor.availability = 'Never available'
      email = welcome_email_for(user)

      expect(email.body).to include('Never available')
    end

    it "contains the mentor's github username" do
      user = user_with_mentor
      email = welcome_email_for(user)

      expect(email.body).to include(user.mentor.github_username)
    end

    it "specifies the subject" do
      user = user_with_mentor
      email = welcome_email_for(user)

      expect(email.subject).to eq(
        I18n.t("mailers.subscription.welcome_from_mentor.subject")
      )
    end

    def user_with_mentor
      build_stubbed(:user, :with_mentor)
    end

    def welcome_email_for(user)
      SubscriptionMailer.welcome_to_prime_from_mentor(user)
    end
  end

  describe '.cancellation_survey' do
    it 'sends a survey to the user who just unsubscribed' do
      user = create(:user)
      email = SubscriptionMailer.cancellation_survey(user)

      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/just canceled/)
    end

    it "specifies the subject" do
      user = build_stubbed(:user)
      email = SubscriptionMailer.cancellation_survey(user)

      expect(email.subject).to eq(
        I18n.t("mailers.subscription.cancellation_survey.subject")
      )
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

    it 'is sent from upcase' do
      expect(subscription_receipt_email.from).to include(ENV["SUPPORT_EMAIL"])
    end

    it "specifies the subject" do
      expect(subscription_receipt_email.subject).to eq(
        I18n.t("mailers.subscription.subscription_receipt.subject")
      )
    end

    def subscription_receipt_email
      SubscriptionMailer.subscription_receipt(
        'email@example.com',
        99,
        'invoice_id'
      )
    end
  end

  describe '.upcoming_payment_notification' do
    include Rails.application.routes.url_helpers

    it 'is sent to the given email' do
      expect(upcoming_payment_notification_email.to).to eq ['email@example.com']
    end

    it 'is sent from upcase' do
      expect(upcoming_payment_notification_email.from).to include ENV["SUPPORT_EMAIL"]
    end

    it 'includes a link to account page' do
      expect(upcoming_payment_notification_email).to have_body_text(my_account_url)
    end

    it 'includes a correct plan name' do
      expect(upcoming_payment_notification_email).to have_body_text('Individual')
    end

    it 'includes the next billing date' do
      expect(upcoming_payment_notification_email).to have_body_text('2014-01-01')
    end

    it "includes the next payment amount" do
      amount_in_cents = 1999
      subscription = build_subscription(next_payment_amount: amount_in_cents)

      result = upcoming_payment_notification_email(subscription)

      expect(result).to have_body_text("$19.99")
    end

    it "specifies the subject" do
      expect(upcoming_payment_notification_email.subject).to eq(
        I18n.t("mailers.subscription.upcoming_payment_notification.subject")
      )
    end

    def upcoming_payment_notification_email(subscription = nil)
      subscription = subscription || build_subscription
      subscription.stubs(plan_name: 'Individual')

      SubscriptionMailer.upcoming_payment_notification(subscription)
    end

    def build_subscription(attributes = {})
      user = build_user
      build_stubbed(
        :subscription,
        {
          next_payment_on: Date.parse('2014-01-01'),
          user: user
        }.merge(attributes)
      )
    end

    def build_user
      build_stubbed(:user, email: 'email@example.com')
    end
  end
end
