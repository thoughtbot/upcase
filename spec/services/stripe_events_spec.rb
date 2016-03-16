require "rails_helper"

describe StripeEvents do
  describe "#customer_subscription_deleted" do
    context "no local subscription record found" do
      it "sends notifications if no subscription is found" do
        allow(Honeybadger).to receive(:notify)

        StripeEvents.new(event).customer_subscription_deleted

        expect(Honeybadger).to have_received(:notify).once
      end
    end

    context "when a local subscription record is found" do
      it "processes the cancellation" do
        subscription = stub_subscription
        cancellation = stub_cancellation

        StripeEvents.new(event).customer_subscription_deleted

        expect(Cancellation).to have_received(:new).
          with(subscription: subscription)
        expect(cancellation).to have_received(:process).once
      end

      it "tracks the user's updated properties" do
        stub_subscription
        stub_cancellation
        tracker = stub_analytics

        StripeEvents.new(event).customer_subscription_deleted

        expect(tracker).to have_received(:track_updated)
      end
    end
  end

  describe "#customer_subscription_updated" do
    context "no local subscription record found" do
      it "sends notifications if no local subscription is found" do
        allow(Honeybadger).to receive(:notify)

        StripeEvents.new(event).customer_subscription_updated

        expect(Honeybadger).to have_received(:notify).once
      end
    end

    context "when a local subscription record is found" do
      it "updates subscription plan if local subscription found" do
        subscription = stub_subscription
        updater = stub_invoice_updater

        StripeEvents.new(event).customer_subscription_updated

        expect(subscription).to have_received(:write_plan).
          with(sku: FakeStripe::PLAN_ID)
        expect(SubscriptionUpcomingInvoiceUpdater).
          to have_received(:new).with([subscription])
        expect(updater).to have_received(:process).once
      end

      it "tracks the user's updated properties" do
        stub_subscription
        stub_invoice_updater
        tracker = stub_analytics

        StripeEvents.new(event).customer_subscription_updated

        expect(tracker).to have_received(:track_updated)
      end
    end
  end

  private

  def stub_subscription
    build_stubbed(:subscription).tap do |subscription|
      allow(Subscription).to receive(:find_by).and_return(subscription)
      allow(subscription).to receive(:write_plan)
    end
  end

  def event
    double(
      "Event",
      data: double("Data", object: stripe_subscription),
      to_hash: {}
    )
  end

  def stripe_subscription
    double(
      "StripeSubscription",
      id: FakeStripe::SUBSCRIPTION_ID,
      plan: double("Plan", id: FakeStripe::PLAN_ID)
    )
  end

  def stub_cancellation
    stub_instance_as_spy Cancellation
  end

  def stub_analytics
    stub_instance_as_spy Analytics
  end

  def stub_invoice_updater
    stub_instance_as_spy SubscriptionUpcomingInvoiceUpdater
  end

  def stub_instance_as_spy(class_to_stub)
    spy(class_to_stub.to_s).tap do |instance|
      allow(class_to_stub).to receive(:new).and_return(instance)
    end
  end
end
