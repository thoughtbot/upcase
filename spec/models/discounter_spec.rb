require "spec_helper"

describe Discounter do
  describe "#switch_to_discounted_annual_plan" do
    it "tells the subscription to change its plan" do
      plan = double("plan", sku: "plan-sku")
      subscription = double("subscription")
      allow(subscription).to receive(:change_plan)

      Discounter.new(
        subscription: subscription,
        discounted_plan: plan
      ).switch_to_discounted_annual_plan

      expect(subscription).to(
        have_received(:change_plan).with(sku: plan.sku)
      )
    end
  end
end
