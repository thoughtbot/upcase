require "rails_helper"

describe "Stripe webhooks" do
  describe "invoice.payment_succeeded" do
    describe "invoice has a subscription" do
      it "sends out a receipt email" do
        invoice_notifier = double("invoice_notifier")
        allow(invoice_notifier).to receive(:send_receipt)
        allow(InvoiceNotifier).to receive(:new).and_return(invoice_notifier)
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
        )

        expect(invoice_notifier).to have_received(:send_receipt)
      end

      it "responds with 200 OK" do
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
        )

        expect(response).to be_success
      end
    end

    context "invoice missing a subscription (user canceled or up/downgraded)" do
      it "sends out a receipt email" do
        invoice_notifier = double("invoice_notifier")
        allow(invoice_notifier).to receive(:send_receipt)
        allow(InvoiceNotifier).to receive(:new).and_return(invoice_notifier)
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER
        )
      end

      it "responds with 200 OK" do
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER
        )

        expect(response).to be_success
      end
    end
  end

  describe "customer.subscription.updated" do
    it "updates upcase subscription" do
      old_plan = create(:plan, sku: "old-plan")
      new_plan = create(:plan, sku: FakeStripe::PLAN_ID)
      subscription = create(
        :subscription,
        plan: old_plan,
        stripe_id: FakeStripe::SUBSCRIPTION_ID
      )
      stripe_invoice = double(
        "StripeInvoice",
        total: 1500, period_end: 1387929600
      )
      allow(Stripe::Invoice).to receive(:upcoming).and_return(stripe_invoice)

      simulate_stripe_webhook_firing(
        FakeStripe::EVENT_ID_FOR_SUBSCRIPTION_UPDATE
      )
      subscription.reload

      expect(subscription.plan).to eq(new_plan)
      expect(subscription.next_payment_amount).to eq(stripe_invoice.total)
      expect(subscription.next_payment_on).to eq(Date.parse("2013-12-25"))
    end
  end

  describe "customer.subscription.deleted" do
    it "deactivates an active subscription" do
      subscription = create(
        :active_subscription,
        stripe_id: FakeStripe::SUBSCRIPTION_ID
      )

      simulate_stripe_webhook_firing(
        FakeStripe::EVENT_ID_FOR_SUBSCRIPTION_DELETION
      )

      expect(subscription.reload).not_to be_active
      expect(response).to be_success
    end

    it "accepts an inactive subscription without error" do
      user = create(
        :subscriber,
        :with_subscription_purchase,
        stripe_customer_id: FakeStripe::CUSTOMER_ID
      )
      user.subscription.deactivate

      simulate_stripe_webhook_firing(
        FakeStripe::EVENT_ID_FOR_SUBSCRIPTION_DELETION
      )

      expect(response).to be_success
    end
  end

  def simulate_stripe_webhook_firing(id)
    post stripe_event_path, id: id
  end
end
