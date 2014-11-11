require "rails_helper"

describe StripeSubscriptionSynchronizer do
  describe "#check_all" do
    it "prints information for out of sync customers" do
      create_user(plan_sku: "not_#{FakeStripe::PLAN_ID}")
      stripe_subscriptions = StripeSubscriptionSynchronizer.new

      output = capture(:stdout) { stripe_subscriptions.check_all }

      expect(output).not_to be_blank
    end

    it "doesn't print for in-sync customers" do
      create_user(plan_sku: FakeStripe::PLAN_ID)
      stripe_subscriptions = StripeSubscriptionSynchronizer.new

      output = capture(:stdout) { stripe_subscriptions.check_all }

      expect(output).to be_blank
    end
  end

  describe "#update_local_stripe_references" do
    it "updates local stripe id references" do
      user = create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

      StripeSubscriptionSynchronizer.new.update_local_stripe_references

      expect(user.subscription.reload.stripe_id).
        to eq(FakeStripe::SUBSCRIPTION_ID)
    end
  end

  def create_user(plan_sku:)
    plan = create(:plan, sku: plan_sku)
    user = create(:user, stripe_customer_id: FakeStripe::CUSTOMER_ID)
    create(:subscription, user: user, plan: plan)
  end
end
