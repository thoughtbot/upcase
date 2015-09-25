require "rails_helper"

describe SubscriptionFulfillment do
  describe '#fulfill' do
    it "fulfills all gained features" do
      user = build_subscribable_user
      plan = build_stubbed(:plan)
      fulfillment = stub_feature_fulfillment

      SubscriptionFulfillment.new(user, plan).fulfill

      expect(fulfillment).to have_received(:fulfill_gained_features)
    end

    it "updates the subscription next invoice information" do
      user = create(:user, :with_subscription)
      plan = create(:plan)
      invoice_updater = double("InvoiceUpdater", process: nil)
      allow(SubscriptionUpcomingInvoiceUpdater).to receive(:new).
        and_return(invoice_updater)

      SubscriptionFulfillment.new(user, plan).fulfill

      expect(SubscriptionUpcomingInvoiceUpdater).
        to have_received(:new).with([user.subscription])
      expect(invoice_updater).to have_received(:process)
    end

    def stub_feature_fulfillment
      spy("FeatureFulfillment").tap do |fulfillment|
        allow(FeatureFulfillment).to receive(:new).and_return(fulfillment)
      end
    end
  end

  describe '#remove' do
    it "unfulfills all lost features" do
      user = build_subscribable_user
      plan = build_stubbed(:plan)
      fulfillment = stub_feature_unfulfillment

      SubscriptionFulfillment.new(user, plan).remove

      expect(fulfillment).to have_received(:unfulfill_lost_features)
    end

    def stub_feature_unfulfillment
      spy("FeatureUnfulfillment").tap do |fulfillment|
        allow(FeatureFulfillment).to receive(:new).and_return(fulfillment)
      end
    end
  end

  def build_subscribable_user
    build_stubbed(:user, :with_github).tap do |user|
      allow(user).to receive(:subscription).
        and_return(build_stubbed(:subscription))
      allow(User).to receive(:find).with(user.id).and_return(user)
    end
  end
end
