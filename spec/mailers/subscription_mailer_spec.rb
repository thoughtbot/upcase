require 'spec_helper'

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
      user.mentor.github_username = 'gituser'
      email = welcome_email_for(user)

      expect(email.body).to include('gituser')
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

