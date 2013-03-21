require 'spec_helper'

describe KissmetricsEventNotifier do
  context 'when the purchase is paid' do
    it 'notifies Kissmetrics of a Billed event' do
      purchase = paid_non_subscription_purchase
      notifier.notify_of(purchase)

      client.should have_received(:record).with(purchase.email,
        'Billed',
        { 'Product Name' => purchase.purchaseable_name, 'Amount Billed' => purchase.price })
    end

    context 'when the purchase is a subscription' do
      it 'notifies Kissmetrics of a Signed Up event' do
        purchase = paid_subscription_purchase

        notifier.notify_of(purchase)
        client.should have_received(:record).with(purchase.email,
          'Signed Up',
          { 'Plan Name' => purchase.purchaseable_sku })
      end
    end

    context 'when the purchase is not a subscription' do
      it 'does not notify Kissmetrics of a Signed Up event' do
        purchase = paid_non_subscription_purchase

        notifier.notify_of(purchase)
        client.should have_received(:record).with(purchase.email,
          'Signed Up',
          { 'Plan Name' => purchase.purchaseable_sku }).never
      end
    end
  end

  context 'when the purchase is not paid' do
    it 'does not notify Kissmetrics of a Billed event' do
      notifier.notify_of(unpaid_purchase)
      client.should have_received(:record).never
    end
  end

  def client
    @client ||= stub('client', :record)
  end

  def notifier
    @notifier ||= KissmetricsEventNotifier.new(client)
  end

  def paid_non_subscription_purchase
    paid_purchase.tap do |stub|
      stub.stubs(subscription?: false, purchaseable_sku: 'book')
    end
  end

  def paid_subscription_purchase
    paid_purchase.tap do |stub|
      stub.stubs(subscription?: true, purchaseable_sku: 'prime')
    end
  end

  def paid_purchase
    purchase.tap do |stub|
      stub.stubs(paid?: true)
    end
  end

  def unpaid_purchase
    purchase.tap do |stub|
      stub.stubs(paid?: false)
    end
  end

  def purchase
    stub('purchase', email: 'foo@bar.com', purchaseable_name: 'Product Name', price: 99)
  end
end
