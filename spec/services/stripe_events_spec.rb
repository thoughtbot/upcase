require "rails_helper"

describe StripeEvents do
  describe "#customer_subscription_deleted" do
    it "sends notifications if no subscription is found" do
      Airbrake.stubs(:notify_or_ignore)

      StripeEvents.new(event).customer_subscription_deleted

      expect(Airbrake).to have_received(:notify_or_ignore).once
    end

    it "cancels plan if subscription found" do
      subscription = stub_subscription
      cancellation = stub(:process)
      Cancellation.stubs(:new).returns(cancellation)

      StripeEvents.new(event).customer_subscription_deleted

      expect(Cancellation).to have_received(:new).with(subscription)
      expect(cancellation).to have_received(:process).once
    end
  end

  describe "#customer_subscription_updated" do
    it "sends notifications if no local subscription is found" do
      Airbrake.stubs(:notify_or_ignore)

      StripeEvents.new(event).customer_subscription_updated

      expect(Airbrake).to have_received(:notify_or_ignore).once
    end

    it "updates subscription plan if local subscription found" do
      subscription = stub_subscription
      updater = stub(:process)
      SubscriptionUpcomingInvoiceUpdater.stubs(new: updater)

      StripeEvents.new(event).customer_subscription_updated

      expect(subscription).to have_received(:write_plan).
        with(sku: FakeStripe::PLAN_ID)
      expect(SubscriptionUpcomingInvoiceUpdater).
        to have_received(:new).with([subscription])
      expect(updater).to have_received(:process).once
    end
  end

  private

  def stub_subscription
    subscription = build_stubbed(:subscription)
    Subscription.stubs(:find_by).returns(subscription)
    subscription.stubs(:write_plan)
    subscription
  end

  def event
    stub(data: stub(object: stripe_subscription), to_hash: {})
  end

  def stripe_subscription
    stub(
      id: FakeStripe::SUBSCRIPTION_ID,
      plan: stub(id: FakeStripe::PLAN_ID)
    )
  end
end
