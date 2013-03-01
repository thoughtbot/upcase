require 'spec_helper'

describe KissmetricsEventNotifier do
  context 'when the purchase is paid' do
    it 'notifies Kissmetrics of a Billed event' do
      client = stub('client', :record)
      notifier = KissmetricsEventNotifier.new(client)
      purchase = stub('purchase', email: 'foo@bar.com', paid?: true, name: 'Product Name', price: 99)

      notifier.notify_of(purchase)
      client.should have_received(:record).with(purchase.email,
                                                'Billed',
                                                { 'Product Name' => purchase.name, 'Amount Billed' => purchase.price })
    end

    context 'when the purchase is for a subscription' do
      it 'notifies Kissmetrics of a Signed Up event' do
      end
    end
  end

  context 'when the purchase is not paid' do
    it 'does not notify Kissmetrics of a Billed event' do
    end
  end
end
