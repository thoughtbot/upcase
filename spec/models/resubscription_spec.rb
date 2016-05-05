require "rails_helper"

describe Resubscription do
  let(:professional) { create(:plan, sku: "professional") }

  context "#fulfill" do
    it "returns false if the user has no credit card" do
      user = create(:user)
      allow(user).to receive(:has_credit_card?).and_return(false)
      resubscription = Resubscription.new(user: user, plan: professional)

      expect(resubscription.fulfill).to be_falsey
    end

    it "returns false if the user has a subscription" do
      user = create(:user, :with_subscription)
      resubscription = Resubscription.new(user: user, plan: professional)

      expect(resubscription.fulfill).to be_falsey
    end

    it "tries to reactivate on the subscription if it can fulfill" do
      user = create(:user, :with_inactive_subscription)
      stripe_customer = stripe_customer_for_user(user)
      resubscription = Resubscription.new(user: user, plan: professional)

      resubscription.fulfill

      expect(user).to have_active_upcase_subscription(professional)
      expect(stripe_customer).to have_active_stripe_subscription(professional)
    end
  end

  def stripe_customer_for_user(user)
    customer = FakeStripeCustomer.new
    allow(Stripe::Customer).
      to receive(:retrieve).
      with(user.stripe_customer_id).
      and_return(customer)
    customer
  end
end
