require 'spec_helper'

describe Subscription do
  it { should belong_to(:team) }
  it { should belong_to(:plan) }
  it { should belong_to(:user) }

  it { should delegate(:stripe_customer_id).to(:user) }

  it { should validate_presence_of(:plan_id) }
  it { should validate_presence_of(:plan_type) }

  it 'defaults paid to true' do
    Subscription.new.should be_paid
  end

  it 'adds the user to the subscriber mailing list' do
    MailchimpFulfillmentJob.stubs(:enqueue)

    subscription = create(:subscription)

    MailchimpFulfillmentJob.should have_received(:enqueue).
      with(Subscription::MAILING_LIST, subscription.user.email)
  end

  it 'adds the user to the subscriber github team' do
    GithubFulfillmentJob.stubs(:enqueue)

    subscription = create(:subscription)

    GithubFulfillmentJob.should have_received(:enqueue).
      with(Subscription::GITHUB_TEAM, [subscription.user.github_username])
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
        plan: create(:downgraded_plan)
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

    it 'removes the user from the subscriber github team' do
      GithubRemovalJob.stubs(:enqueue)

      subscription = create(:subscription)
      subscription.deactivate

      GithubRemovalJob.should have_received(:enqueue).
        with(Subscription::GITHUB_TEAM, [subscription.user.github_username])
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

  describe '#change_plan' do
    it 'updates the plan in Stripe' do
      different_plan = create(:plan, sku: 'different')
      subscription = create(:active_subscription)
      stripe_customer = stub(update_subscription: nil)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      subscription.change_plan(different_plan)

      expect(stripe_customer).
        to have_received(:update_subscription).
        with(plan: different_plan.sku)
    end

    it 'changes the subscription plan to the given plan' do
      different_plan = create(:plan, sku: 'different')
      subscription = create(:active_subscription)

      subscription.change_plan(different_plan)

      expect(subscription.plan).to eq different_plan
    end
  end

  describe "#downgraded?" do
    it 'is downgraded if it has the downgraded plan' do
      downgraded_plan = create(:downgraded_plan)
      subscription = create(:active_subscription)

      subscription.change_plan(downgraded_plan)

      expect(subscription).to be_downgraded
    end
  end

  describe '.canceled_in_last_30_days' do
    it 'returns nothing when none have been canceled within 30 days' do
      create(:subscription, deactivated_on: 60.days.ago)

      expect(Subscription.canceled_in_last_30_days).to be_empty
    end

    it 'returns the subscriptions canceled within 30 days' do
      subscription = create(:subscription, deactivated_on: 7.days.ago)

      expect(Subscription.canceled_in_last_30_days).to eq [subscription]
    end
  end

  describe '.active_as_of' do
    it 'returns nothing when no subscriptions canceled' do
      expect(Subscription.active_as_of(Time.zone.now)).to be_empty
    end

    it 'returns nothing when subscription canceled before the given date' do
      create(:subscription, deactivated_on: 9.days.ago)

      expect(Subscription.active_as_of(8.days.ago)).to be_empty
    end

    it 'returns the subscriptions canceled after the given date' do
      subscription = create(:subscription, deactivated_on: 7.days.ago)

      expect(Subscription.active_as_of(8.days.ago)).to eq [subscription]
    end

    it 'returns the subscriptions not canceled' do
      subscription = create(:subscription)

      expect(Subscription.active_as_of(8.days.ago)).to eq [subscription]
    end
  end

  describe '.created_before' do
    it 'returns nothing when the are no subscriptions' do
      expect(Subscription.created_before(Time.zone.now)).to be_empty
    end

    it 'returns nothing when nothing has been created before the given date' do
      create(:subscription, created_at: 1.day.ago)

      expect(Subscription.created_before(2.days.ago)).to be_empty
    end

    it 'returns the subscriptions created before the given date' do
      subscription = create(:subscription, created_at: 2.days.ago)

      expect(Subscription.created_before(1.day.ago)).to eq [subscription]
    end
  end
end
