require 'spec_helper'

describe Subscription do
  it { should delegate(:stripe_customer_id).to(:user) }
  it { should belong_to(:mentor) }

  it 'defaults paid to true' do
    Subscription.new.should be_paid
  end

  it 'adds the user to the subscriber mailing list' do
    MailchimpFulfillmentJob.stubs(:enqueue)

    subscription = create(:subscription)

    MailchimpFulfillmentJob.should have_received(:enqueue).
      with(Subscription::MAILING_LIST, subscription.user.email)
  end

  describe 'self.paid' do
    it 'only includes paid subscriptions' do
      paid = create(:subscription, paid: true)
      free = create(:subscription, paid: false)

      Subscription.paid.should_not include(free)
      Subscription.paid.should include(paid)
    end
  end

  describe '.deliver_welcome_emails' do
    it 'sends emails for each new mentored subscriber in the last 24 hours' do
      old_subscription = create(:subscription, created_at: 25.hours.ago)
      new_subscription = create(:subscription, created_at: 10.hours.ago)
      new_basic_subscription = create(
        :subscription,
        created_at: 10.hours.ago,
        plan: create(:downgrade_plan)
      )
      mailer = stub(deliver: true)
      SubscriptionMailer.stubs(welcome_to_prime: mailer)
      SubscriptionMailer.stubs(welcome_to_prime_from_mentor: mailer)

      Subscription.deliver_welcome_emails

      expect(SubscriptionMailer).
        to have_received(:welcome_to_prime_from_mentor).
        with(new_subscription.user)
      expect(SubscriptionMailer).
        to have_received(:welcome_to_prime).
        with(new_basic_subscription.user)
      expect(SubscriptionMailer).
        to have_received(:welcome_to_prime).
        with(old_subscription.user).never
      expect(mailer).to have_received(:deliver).twice
    end
  end

  describe '.deliver_byte_notifications' do
    it 'initializes the ArticleNotifier with subscriber emails' do
      inactive_subscription = create(:inactive_subscription)
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
      byte = create(:byte, published_on: Time.zone.today, body: 'test')

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
      subscription = Subscription.new(deactivated_on: Time.zone.today)
      subscription.should_not be_active
    end
  end

  describe '#deactivate' do
    it "updates the subscription record by setting deactivated_on to today" do
      subscription = create(:active_subscription)

      subscription.deactivate
      subscription.reload

      expect(subscription.deactivated_on).to eq Time.zone.today
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

    it 'removes the user from the subscriber mailing list' do
      MailchimpRemovalJob.stubs(:enqueue)

      subscription = create(:subscription)
      subscription.deactivate

      MailchimpRemovalJob.should have_received(:enqueue).
        with(Subscription::MAILING_LIST, subscription.user.email)
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

  describe "#downgrade" do
    it "updates the subscription record by setting deactivated_on to today" do
      downgraded_plan = create(:plan, sku: Subscription::DOWNGRADED_PLAN)
      subscription = create(:active_subscription)
      stripe_customer = stub(
        'Stripe::Customer',
        update_subscription: nil
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      subscription.downgrade
      subscription.reload

      stripe_customer.should have_received(:update_subscription).
        with(plan: Subscription::DOWNGRADED_PLAN)
      expect(subscription.plan).to eq downgraded_plan
    end
  end

  describe "#downgraded?" do
    it 'is downgraded if it is downgraded' do
      create(:plan, sku: Subscription::DOWNGRADED_PLAN)
      subscription = create(:active_subscription)
      expect(subscription).not_to be_downgraded

      subscription.downgrade

      expect(subscription).to be_downgraded
    end
  end
end
