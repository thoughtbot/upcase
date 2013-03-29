require 'spec_helper'

describe Subscription do
  it { should delegate(:stripe_customer).to(:user) }

  describe '.recent' do
    it 'returns the subscriptions that are less than 24 hours old' do
      old_subscription = create :subscription, created_at: 25.hours.ago
      new_subscription = create :subscription, created_at: 10.hours.ago

      expect(Subscription.recent).to eq([new_subscription])
    end
  end

  describe '.send_welcome_emails' do
    it 'sends emails for each new subscriber in the last 24 hours' do
      old_subscription = create :subscription, created_at: 25.hours.ago
      new_subscription = create :subscription, created_at: 10.hours.ago
      mailer = stub(deliver: true)
      Mailer.stubs(welcome_to_prime: mailer)

      Subscription.deliver_welcome_emails

      expect(Mailer).to have_received(:welcome_to_prime).with(new_subscription.user)
      expect(Mailer).to have_received(:welcome_to_prime).with(old_subscription.user).never
      expect(mailer).to have_received(:deliver).once
    end
  end
end
