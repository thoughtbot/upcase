require "spec_helper"

describe CheckoutBuilder do
  describe "#build" do
    it "sets the user if the user is present" do
      user = build_stubbed(:user)

      checkout = build_checkout(params: checkout_params, user: user)

      expect(checkout.user).to eq(user)
    end

    it "sets the stripe id if user is present and using an existing card" do
      user = build_stubbed(:user, stripe_customer_id: "stripe-id-123")

      checkout =
        build_checkout(
          params: checkout_params(use_existing_card: "on"),
          user: user
        )

      expect(checkout.stripe_customer_id).to eq("stripe-id-123")
    end

    it "does not set the stripe id if there is no user" do
      checkout =
        build_checkout(params: checkout_params(use_existing_card: "on"))

      expect(checkout.stripe_customer_id).to be_nil
    end

    it "does not set the stripe id if we are not using an existing card" do
      user = build_stubbed(:user, stripe_customer_id: "cus12345")

      checkout =
        build_checkout(
          params: checkout_params(use_existing_card: "off"),
          user: user
        )

      expect(checkout.stripe_customer_id).to be_nil
    end

    def checkout_params(params = {})
      params[:checkout] ||= { name: "anything" }
      ActionController::Parameters.new(params)
    end

    def build_checkout(options)
      params = options[:params] || checkout_params
      user = options[:user]

      checkouts = create(:individual_plan).checkouts

      CheckoutBuilder.new(
        params: params,
        user: user,
        checkouts_collection: checkouts
      ).build
    end
  end
end
