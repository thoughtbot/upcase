require 'spec_helper'

describe 'Stripe webhooks', :type => :request do
  describe 'invoice.payment_succeeded' do
    describe 'invoice has a subscription' do
      it 'sends out a receipt email' do
        invoice_notifier = stub('invoice_notifier')
        invoice_notifier.stubs(:send_receipt)
        InvoiceNotifier.stubs(:new).returns(invoice_notifier)
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
        )

        expect(invoice_notifier).to have_received(:send_receipt)
      end

      it 'responds with 200 OK' do
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
        )

        expect(response).to be_success
      end
    end

    context 'invoice missing a subscription (user canceled or up/downgraded)' do
      it 'sends out a receipt email' do
        invoice_notifier = stub('invoice_notifier')
        invoice_notifier.stubs(:send_receipt)
        InvoiceNotifier.stubs(:new).returns(invoice_notifier)
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER
        )
      end

      it 'responds with 200 OK' do
        create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

        simulate_stripe_webhook_firing(
          FakeStripe::EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER
        )

        expect(response).to be_success
      end
    end
  end

  describe 'customer.subscription.deleted' do
    it "deactivates an active subscription" do
      user = create(
        :subscriber,
        :with_subscription_purchase,
        stripe_customer_id: FakeStripe::CUSTOMER_ID
      )

      simulate_stripe_webhook_firing(
        FakeStripe::EVENT_ID_FOR_SUBSCRIPTION_DELETION
      )

      expect(user.reload).not_to have_active_subscription
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
    post '/stripe-webhook', 'id' => id
  end
end
