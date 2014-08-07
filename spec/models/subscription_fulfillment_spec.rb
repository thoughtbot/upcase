require 'spec_helper'

describe SubscriptionFulfillment, :type => :model do
  describe '#fulfill' do
    it "downloads the user's GitHub public keys" do
      GitHubPublicKeyDownloadFulfillmentJob.stubs(:enqueue)
      user = build_subscribable_user
      plan = build_stubbed(:individual_plan)

      SubscriptionFulfillment.new(user, plan).fulfill

      expect(GitHubPublicKeyDownloadFulfillmentJob).to have_received(:enqueue)
        .with(user.id)
    end

    it "fulfills all gained features" do
      user = build_subscribable_user
      plan = build_stubbed(:individual_plan)
      fulfillment = stub_feature_fulfillment

      SubscriptionFulfillment.new(user, plan).fulfill

      expect(fulfillment).to have_received(:fulfill_gained_features)
    end

    def stub_feature_fulfillment
      stub(fulfill_gained_features: nil).tap do |fulfillment|
        FeatureFulfillment.stubs(:new).returns(fulfillment)
      end
    end
  end

  describe '#remove' do
    it 'removes all subscription licenses' do
      user = build_subscribable_user
      licenses = stub_subscription_licenses(user)
      plan = build_stubbed(:individual_plan)

      SubscriptionFulfillment.new(user, plan).remove

      expect(licenses).to have_received(:destroy)
    end

    it "unfulfills all lost features" do
      user = build_subscribable_user
      plan = build_stubbed(:individual_plan)
      fulfillment = stub_feature_unfulfillment

      SubscriptionFulfillment.new(user, plan).remove

      expect(fulfillment).to have_received(:unfulfill_lost_features)
    end

    def stub_feature_unfulfillment
      stub(unfulfill_lost_features: nil).tap do |fulfillment|
        FeatureFulfillment.stubs(:new).returns(fulfillment)
      end
    end

    def stub_subscription_licenses(user)
      licenses = stub(destroy: true)
      user.stubs(:licenses).returns(licenses)
      licenses
    end
  end

  def build_subscribable_user
    build_stubbed(:user, :with_github).tap do |user|
      user.stubs(:assign_mentor)
      User.stubs(:find).with(user.id).returns(user)
    end
  end
end
