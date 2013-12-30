require 'spec_helper'

describe SubscriptionFulfillment do
  describe '#fulfill' do
    it 'adds a subscription to the user that created the purchase' do
      create_mentors
      user = create(:user, :with_github)
      purchase = build(:plan_purchase, user: user)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase, user).fulfill

      expect(user.subscription).not_to be_nil
      expect(user.subscription.plan).to eq purchase.purchaseable
    end

    it "doesn't add a subscription to a user that didn't create the purchase" do
      user = create(:user, :with_github)
      purchase = build(:plan_purchase)

      SubscriptionFulfillment.new(purchase, user).fulfill

      expect(user.subscription).to be_nil
    end

    it 'assigns a mentor on creation' do
      create_mentors
      mentor = Mentor.first
      user = create(:user, :with_github)
      purchase = build(:plan_purchase, mentor_id: mentor.id)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase, user).fulfill

      expect(user.mentor).not_to be_nil
    end

    it 'adds the user to the subscriber github team' do
      GithubFulfillmentJob.stubs(:enqueue)
      user = create(:user, :with_github)
      purchase = build(:plan_purchase)

      SubscriptionFulfillment.new(purchase, user).fulfill

      GithubFulfillmentJob.should have_received(:enqueue).
        with(SubscriptionFulfillment::GITHUB_TEAM, [user.github_username])
    end
  end

  describe '#remove' do
    it 'removes the user from the subscriber github team' do
      GithubRemovalJob.stubs(:enqueue)
      user = create(:user, :with_github)
      purchase = build(:plan_purchase)

      SubscriptionFulfillment.new(purchase, user).remove

      GithubRemovalJob.should have_received(:enqueue).
        with(SubscriptionFulfillment::GITHUB_TEAM, [user.github_username])
    end

    it 'removes all subscription purchases' do
      user = create(:user, :with_github)
      create_subscription_purchase(user)
      book_purchase = create_paid_purchase(user)
      github_fulfillment = stub_github_fulfillment
      plan_purchase = build(:plan_purchase)

      SubscriptionFulfillment.new(plan_purchase, user).remove

      user.paid_purchases.count.should eq 1
      user.paid_purchases.should eq [book_purchase]
      user.subscription_purchases.count.should eq 0
      github_fulfillment.should have_received(:remove)
    end

    def create_subscription_purchase(user)
      product = create(:book, :github)
      subscription_purchase = SubscriberPurchase.new(product, user)
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
