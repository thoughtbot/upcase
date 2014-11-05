require "rails_helper"

describe CustomerWithSubscription do
  describe "#has_out_of_sync_user?" do
    it "returns false if there's no local user" do
      checker = CustomerWithSubscription.new(stripe_customer)

      expect(checker).not_to have_out_of_sync_user
    end

    it "returns false if upcase customer has same plan" do
      user = create(:subscriber)
      customer =
        stripe_customer_for(user, plan_id: user.purchased_subscription.plan.sku)
      checker = CustomerWithSubscription.new(customer)

      expect(checker).not_to have_out_of_sync_user
    end

    it "returns true if upcase customer has another plan" do
      user = create(:subscriber)
      customer = stripe_customer_for(user, plan_id: "other-plan")
      checker = CustomerWithSubscription.new(customer)

      expect(checker).to have_out_of_sync_user
    end
  end

  describe "#to_s" do
    it "inspects the customer, subscription, user, and plan" do
      user = create(:subscriber)
      customer = stripe_customer_for(user, plan_id: "plan_id")
      checker = CustomerWithSubscription.new(customer)

      result = checker.to_s

      expect(result).to eq(<<-EOS.squish)
        Customer #{customer["id"]} has subscription plan_id in Stripe, and
        #{user.purchased_subscription.plan.sku} in Upcase
      EOS
    end
  end

  def stripe_customer_for(user, plan_id:)
    {
      "id" => user.stripe_customer_id,
      "subscriptions" => {
        "data" => [
          "plan" => { "id" => plan_id }
        ]
      }
    }
  end

  def stripe_customer(plan_id: "any")
    {
      "id" => "cus_stripe_id",
      "subscriptions" => {
        "data" => ["plan" => { "id" => plan_id }]
      }
    }
  end
end
