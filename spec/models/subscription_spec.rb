require 'spec_helper'

describe Subscription do
  it { should delegate(:stripe_customer_id).to(:user) }

  describe '.deliver_welcome_emails' do
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

  describe '.deliver_byte_notifications' do
    it 'initializes the ArticleNotifier with subscriber emails' do
      subscription = create(:subscription)
      notifier = stub(send_notifications: nil)
      ByteNotifier.stubs(new: notifier)

      Subscription.deliver_byte_notifications

      expect(ByteNotifier).to have_received(:new).
        with([subscription.user.email])
      expect(notifier).to have_received(:send_notifications)
    end

    it 'delivers a byte notification to each subscriber' do
      subscription = create(:subscription)
      article = create(:article, published_on: Date.today, body: 'test')

      Subscription.deliver_byte_notifications

      result = ActionMailer::Base.deliveries.any? do |email|
        email.to == [subscription.user.email] && email.subject =~ /Byte/i
      end
      expect(result).to eq true
    end
  end

  describe '#active?' do
    it "returns true if deactivated_on is nil" do
      subscription = Subscription.new(deactivated_on: nil)
      subscription.should be_active
    end

    it "returns false if deactivated_on is not nil" do
      subscription = Subscription.new(deactivated_on: Date.today)
      subscription.should_not be_active
    end
  end

  describe '#deactivate' do
    it "updates the subscription record by setting deactivated_on to today" do
      subscription = create(:active_subscription)

      subscription.deactivate
      subscription.reload

      expect(subscription.deactivated_on).to eq Date.today
    end

    it 'removes all subscription purchases' do
      subscription = create(:active_subscription)
      user = subscription.user
      create_subscription_purchase(user)
      book_purchase = create_paid_purchase(user)
      github_fulfillment = stub_github_fulfillment

      subscription.deactivate

      user.paid_purchases.count.should eq 1
      user.paid_purchases.should eq [book_purchase]
      user.subscription_purchases.count.should eq 0
      github_fulfillment.should have_received(:remove)
    end

    def create_subscription_purchase(user)
      github_book_product = create(:github_book_product)
      subscription_purchase = SubscriberPurchase.new(github_book_product, user)
      subscription_purchase.create
    end

    def create_paid_purchase(user)
      create(:book_purchase, user: user)
    end

    def stub_github_fulfillment
      github_fulfillment = stub(remove: nil)
      GithubFulfillment.stubs(:new).returns(github_fulfillment)
      github_fulfillment
    end
  end
end
