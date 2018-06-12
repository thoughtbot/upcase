require "rails_helper"

describe TapasPaymentsController do
  describe "#create" do
    context "when tier 1 is purchased" do
      it "creates a charge in Stripe" do
        allow(Stripe::Charge).to receive(:create)
        tier = 1
        email = "foo@bar.com"

        post(
          :create,
          params: {
            "stripeToken" => "tok",
            "stripeEmail" => email,
            tier: tier,
          },
        )

        expect(Stripe::Charge).to(
          have_received(:create).with(
            amount: TapasPaymentsController::TIER_1_PRICE,
            currency: "USD",
            source: "tok",
            receipt_email: email,
            metadata: { email: email, tier: tier, quantity: 1 },
            description: "Upcase/RubyTapas bundle",
          )
        )
      end
    end

    context "when tier 2 is purchased" do
      it "creates a charge in Stripe" do
        allow(Stripe::Charge).to receive(:create)
        tier = 2
        email = "foo@bar.com"

        post(
          :create,
          params: {
            "stripeToken" => "tok",
            "stripeEmail" => email,
            tier: tier,
          },
        )

        expect(Stripe::Charge).to(
          have_received(:create).with(
            amount: TapasPaymentsController::TIER_2_PRICE,
            currency: "USD",
            source: "tok",
            receipt_email: email,
            metadata: { email: email, tier: tier, quantity: 1 },
            description: "Upcase/RubyTapas bundle",
          )
        )
      end
    end

    context "when tier 3 is purchased" do
      it "creates a charge in Stripe" do
        allow(Stripe::Charge).to receive(:create)
        quantity = 4
        tier = 3
        email = "foo@bar.com"

        post(
          :create,
          params: {
            "stripeToken" => "tok",
            "stripeEmail" => email,
            quantity: quantity,
            tier: tier,
          },
        )

        expect(Stripe::Charge).to(
          have_received(:create).with(
            amount: quantity * TapasPaymentsController::TIER_3_PRICE,
            currency: "USD",
            source: "tok",
            receipt_email: email,
            metadata: { email: email, tier: tier, quantity: quantity },
            description: "Upcase/RubyTapas bundle",
          )
        )
      end

      context "when tier 4 is purchased" do
        it "creates a charge in Stripe" do
          allow(Stripe::Charge).to receive(:create)
          quantity = 3
          tier = 4
          email = "foo@bar.com"

          post(
            :create,
            params: {
              "stripeToken" => "tok",
              "stripeEmail" => email,
              quantity: quantity,
              tier: tier,
            },
          )

          expect(Stripe::Charge).to(
            have_received(:create).with(
              amount: quantity * TapasPaymentsController::TIER_4_PRICE,
              currency: "USD",
              source: "tok",
              receipt_email: email,
              metadata: { email: email, tier: tier, quantity: quantity },
              description: "Upcase/RubyTapas bundle",
            )
          )
        end
      end

      context "when the charge fails" do
        it "tells the user and asks them to fix it" do
          allow(Stripe::Charge).to(
            receive(:create).
            and_raise(Stripe::CardError.new(nil, nil, nil)),
          )
          tier = 1
          email = "foo@bar.com"

          post(
            :create,
            params: {
              "stripeToken" => "tok",
              "stripeEmail" => email,
              tier: tier,
            },
          )

          expect(response).to render_template(:error)
        end
      end
    end
  end
end
