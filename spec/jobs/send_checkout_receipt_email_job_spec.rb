require 'spec_helper'

describe SendCheckoutReceiptEmailJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  describe '.enqueue' do
    it 'enqueues a job' do
      checkout = create(:checkout)

      SendCheckoutReceiptEmailJob.enqueue(checkout.id).should
        enqueue_delayed_job(SendCheckoutReceiptEmailJob)
    end
  end

  describe '#perform' do
    it 'sends a checkout receipt' do
      checkout = stubbed_checkout
      mail_stub = stub_mail_method(CheckoutMailer, :receipt)

      SendCheckoutReceiptEmailJob.new(checkout.id).perform

      CheckoutMailer.should have_received(:receipt).with(checkout)
      mail_stub.should have_received(:deliver)
    end
  end
end
