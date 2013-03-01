require 'spec_helper'

describe KissmetricsEventNotifier do
  context 'when the purchase is paid' do
    it 'notifies Kissmetrics of a Billed event' do
      purchase.stubs(paid?: true, subscription?: false)

      notifier.notify_of(purchase)
      client.should have_received(:record).with(purchase.email,
                                                'Billed',
                                                { 'Product Name' => purchase.name, 'Amount Billed' => purchase.price })
    end

    context 'when the purchase is a subscription' do
      it 'notifies Kissmetrics of a Signed Up event' do
        purchase.stubs(subscription?: true, paid?: true)

        notifier.notify_of(purchase)
        client.should have_received(:record).with(purchase.email,
                                                  'Signed Up',
                                                  { 'Plan Name' => Purchase::PLAN_NAME })
      end
    end

    context 'when the purchase is not a subscription' do
      it 'does not notify Kissmetrics of a Signed Up event' do
        purchase.stubs(subscription?: false, paid?: true)

        notifier.notify_of(purchase)
        client.should have_received(:record).with(purchase.email,
                                                  'Signed Up',
                                                  { 'Plan Name' => Purchase::PLAN_NAME }).never
      end
    end
  end

  context 'when the purchase is not paid' do
    it 'does not notify Kissmetrics of a Billed event' do
      purchase.stubs(paid?: false)

      notifier.notify_of(purchase)
      client.should have_received(:record).never
    end
  end

  def client
    @client ||= stub('client', :record)
  end

  def notifier
    @notifier ||= KissmetricsEventNotifier.new(client)
  end

  def purchase
    @purchase ||= stub('purchase', email: 'foo@bar.com', name: 'Product Name', price: 99)
  end
end
