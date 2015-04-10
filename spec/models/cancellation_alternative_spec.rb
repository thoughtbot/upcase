require "spec_helper"

describe CancellationAlternative do
  describe "#can_switch_to_discounted_plan?" do
    context "when the user isn't already on the discounted plan" do
      it "returns true" do
        discounted_plan = double("discounted-plan")
        other_plan = double("other-plan")

        result = CancellationAlternative.new(
          current_plan: other_plan,
          discounted_plan: discounted_plan,
        ).can_switch_to_discounted_plan?

        expect(result).to be_truthy
      end
    end

    context "when the user is already on the discounted plan" do
      it "returns false" do
        discounted_plan = double("discounted-plan")

        result = CancellationAlternative.new(
          current_plan: discounted_plan,
          discounted_plan: discounted_plan,
        ).can_switch_to_discounted_plan?

        expect(result).to be_falsey
      end
    end
  end

  describe "#discount_percentage" do
    it "returns the percentage discount that the alternative offers" do
      current_plan = double("current_plan", price_in_dollars: 10)
      discounted_plan = double("discounted_plan", price_in_dollars: 60)

      result = CancellationAlternative.new(
        current_plan: current_plan,
        discounted_plan: discounted_plan
      ).discount_percentage_vs_current_plan_annualized

      expect(result).to eq 50
    end
  end

  describe "#discount_plan_price" do
    it "returns the price of the discounted plan" do
      current_plan = double("current_plan")
      discounted_plan = double("discounted_plan", price_in_dollars: 60)

      result = CancellationAlternative.new(
        current_plan: current_plan,
        discounted_plan: discounted_plan
      ).discount_plan_price

      expect(result).to eq 60
    end
  end
end
