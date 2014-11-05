require "rails_helper"

describe StripeSubscriptionsChecker do
  describe "#check_all" do
    it "prints information for out of sync customers" do
      create_user(plan_sku: "not_#{FakeStripe::PLAN_ID}")
      checker = StripeSubscriptionsChecker.new(output: stdout)

      checker.check_all

      expect(output).not_to be_blank
    end

    it "doesn't print for in-sync customers" do
      create_user(plan_sku: FakeStripe::PLAN_ID)
      checker = StripeSubscriptionsChecker.new(output: stdout)

      checker.check_all

      expect(output).to be_blank
    end
  end

  def create_user(plan_sku:)
    plan = create(:plan, sku: plan_sku)
    user = create(:user, stripe_customer_id: FakeStripe::CUSTOMER_ID)
    create(:subscription, user: user, plan: plan)
  end

  let(:output) do
    stdout.rewind
    stdout.read
  end

  let(:stdout) { StringIO.new("") }
end
