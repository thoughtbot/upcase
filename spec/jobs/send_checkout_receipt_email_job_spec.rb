require "rails_helper"

describe SendCheckoutReceiptEmailJob do
  it_behaves_like "a Delayed Job that notifies Honeybadger about errors"

  describe '#perform' do
    it 'sends a checkout receipt' do
      checkout = stubbed_checkout
      mail_stub = stub_mail_method(CheckoutMailer, :receipt)

      SendCheckoutReceiptEmailJob.perform_later(checkout.id)

      expect(CheckoutMailer).to have_received(:receipt).with(checkout)
      expect(mail_stub).to have_received(:deliver_now)
    end
  end
end
