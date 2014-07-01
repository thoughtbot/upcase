require 'spec_helper'

describe SubscriptionFulfillment do
  describe '#fulfill' do
    it 'adds a subscription to the user that created the purchase' do
      user = build_subscribable_user
      purchase = build_stubbed(:plan_purchase, user: user)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase, user).fulfill

      expect(user.subscription).not_to be_nil
      expect(user.subscription.plan).to eq purchase.purchaseable
    end

    it "doesn't add a subscription to a user that didn't create the purchase" do
      user = build_subscribable_user
      purchase = build_stubbed(:plan_purchase)

      SubscriptionFulfillment.new(purchase, user).fulfill

      expect(user.subscription).to be_nil
    end

    it "downloads the user's GitHub public keys" do
      GitHubPublicKeyDownloadFulfillmentJob.stubs(:enqueue)
      user = build_subscribable_user
      purchase = build_stubbed(:plan_purchase)

      SubscriptionFulfillment.new(purchase, user).fulfill

      GitHubPublicKeyDownloadFulfillmentJob.should have_received(:enqueue)
        .with(user.id)
    end

    it "fulfills all gained features" do
      user = build_subscribable_user
      purchase = build_stubbed(:plan_purchase)
      fulfillment = stub_feature_fulfillment

      SubscriptionFulfillment.new(purchase, user).fulfill

      expect(fulfillment).to have_received(:fulfill_gained_features)
    end

    def stub_feature_fulfillment
      stub(fulfill_gained_features: nil).tap do |fulfillment|
        FeatureFulfillment.stubs(:new).returns(fulfillment)
      end
    end
  end

  describe '#remove' do
    it 'removes all subscription purchases' do
      user = build_subscribable_user
      purchases = stub_subscription_purchases(user)
      refunders = stub_refunds(purchases)
      plan_purchase = build_stubbed(:plan_purchase)

      SubscriptionFulfillment.new(plan_purchase, user).remove

      refunders.each do |refunder|
        expect(refunder).to have_received(:refund)
      end
    end

    it "unfulfills all lost features" do
      user = build_subscribable_user
      purchase = build_stubbed(:plan_purchase)
      fulfillment = stub_feature_unfulfillment

      SubscriptionFulfillment.new(purchase, user).remove

      expect(fulfillment).to have_received(:unfulfill_lost_features)
    end

    def stub_feature_unfulfillment
      stub(unfulfill_lost_features: nil).tap do |fulfillment|
        FeatureFulfillment.stubs(:new).returns(fulfillment)
      end
    end

    def stub_subscription_purchases(user)
      [build_stubbed(:purchase), build_stubbed(:purchase)].tap do |purchases|
        user.stubs(:subscription_purchases).returns(purchases)
      end
    end

    def stub_refunds(purchases)
      purchases.map do |purchase|
        stub('refunder').tap do |refunder|
          PurchaseRefunder.stubs(:new).with(purchase).returns(refunder)
          refunder.stubs(:refund)
        end
      end
    end
  end

  def build_subscribable_user
    build_stubbed(:user, :with_github).tap do |user|
      user.stubs(:assign_mentor)
      User.stubs(:find).with(user.id).returns(user)
    end
  end
end
