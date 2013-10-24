require 'spec_helper'

describe InvoicePaymentProcessor do
  describe '.send_receipt_and_notify_kissmetrics' do
    it 'sends a receipt and notifies kissmetrics' do
      stub_payment_processor = stub('payment_processor', send_receipt: true, notify_of_subscription_billing: true)
      InvoicePaymentProcessor.stubs(new: stub_payment_processor)
      InvoicePaymentProcessor.send_receipt_and_notify_of_subscription_billing(stub_invoice)

      expect(stub_payment_processor).to have_received(:send_receipt)
      expect(stub_payment_processor).to have_received(:notify_of_subscription_billing)
    end
  end

  describe '#send_receipt' do
    context 'invoice has a user' do
      it 'sends a receipt to the person who was charged' do
        ActionMailer::Base.deliveries.clear
        payment_processor = InvoicePaymentProcessor.new(stub_invoice)

        payment_processor.send_receipt

        customer_should_receive_receipt_email(stub_invoice)
      end
    end

    context 'invoice has no user' do
      it 'does not send a receipt' do
        ActionMailer::Base.deliveries.clear
        payment_processor = InvoicePaymentProcessor.new(stub_invoice_without_matching_customer_id)

        payment_processor.send_receipt

        customer_should_not_receive_receipt_email
      end
    end
  end

  describe '#notify_of_subscription_billing' do
    context 'invoice has a user' do
      it 'sends the subscription billing event to Kissmetrics' do
        payment_processor = InvoicePaymentProcessor.new(stub_invoice)
        payment_processor.notify_of_subscription_billing

        kissmetrics_should_receive_succesful_charge_event(stub_invoice.user_email)
      end
    end

    context 'invoice does not have a user' do
      it 'does not send an event to Kissmetrics' do
        payment_processor = InvoicePaymentProcessor.new(stub_invoice_without_matching_customer_id)
        payment_processor.notify_of_subscription_billing

        kissmetrics_should_not_receive_succesful_charge_event
      end

      it 'sends a notification to Airbrake for further debugging' do
        Airbrake.stubs(:notify_or_ignore)
        payment_processor = InvoicePaymentProcessor.new(stub_invoice_without_matching_customer_id)
        payment_processor.notify_of_subscription_billing

        expect(Airbrake).to have_received(:notify_or_ignore)
      end
    end
  end

  def stub_invoice
    stub('invoice', user: true, user_email: 'someone@example.com', subscription_item_name: 'something', amount_paid: '$500', stripe_invoice_id: 'stripe_id')
  end

  def stub_invoice_without_matching_customer_id
    stub('invoice', user: nil, user_email: nil, subscription_item_name: 'something', amount_paid: '$500', stripe_invoice_id: 'stripe_id', stripe_invoice: nil)
  end

  def customer_should_receive_receipt_email(invoice)
    email = ActionMailer::Base.deliveries.first
    email.subject.should include('receipt')
    email.to.should eq [invoice.user_email]
  end

  def customer_should_not_receive_receipt_email
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  def kissmetrics_should_receive_succesful_charge_event(email)
    expect(FakeKissmetrics.events_for(email)).to be_present
  end

  def kissmetrics_should_not_receive_succesful_charge_event
    expect(KissmetricsEventNotifier).to have_received(:new).never
  end
end
