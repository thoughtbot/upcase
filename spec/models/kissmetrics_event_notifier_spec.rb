require 'spec_helper'

describe KissmetricsEventNotifier do
  context '#notify_of_purchase' do
    context 'when the purchase is paid' do
      context 'when the purchase is a subscription' do
        it 'notifies Kissmetrics of a Signed Up event' do
          purchase = paid_subscription_purchase

          notifier.notify_of_purchase(purchase)
          client.should have_received(:record).with(purchase.email,
            'Signed Up',
            { 'Plan Name' => purchase.purchaseable_sku })
        end

        it 'does not notify Kissmetrics of a Subscription Billed event' do
          purchase = paid_subscription_purchase

          notifier.notify_of_purchase(purchase)

          client.should have_received(:record).with(
            purchase.email,
            'Subscription Billed',
            { 'Subscription Billing Amount' => purchase.price }).never
        end
      end

      context 'when the purchase is not a subscription' do
        it 'notifies Kissmetrics of a Billed event' do
          purchase = paid_non_subscription_purchase

          notifier.notify_of_purchase(purchase)

          client.should have_received(:record).with(purchase.email,
            'Billed',
            { 'Product Name' => purchase.purchaseable_name, 'Amount Billed' => purchase.price })
        end

        it 'does not notify Kissmetrics of a Signed Up event' do
          purchase = paid_non_subscription_purchase

          notifier.notify_of_purchase(purchase)

          client.should have_received(:record).with(purchase.email,
            'Signed Up',
            { 'Plan Name' => purchase.purchaseable_sku }).never
        end
      end
    end

    context 'when the purchase is not paid' do
      it 'does not notify Kissmetrics of a Billed event' do
        notifier.notify_of_purchase(unpaid_purchase)
        client.should have_received(:record).never
      end
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
      stub('purchase', email: 'foo@bar.com', purchaseable_name: 'Product Name', price: 99, id: 123)
    end
  end

  context '#notify_of_subscription_billing' do
    it 'notifies Kissmetrics of a Subscription Billed event' do
      notifier.notify_of_subscription_billing('foo@bar.com', 99)

      client.should have_received(:record).with(
        'foo@bar.com',
        'Subscription Billed',
        { 'Subscription Billing Amount' => 99 })
    end
  end

  def client
    @client ||= stub('client', :record)
  end

  def notifier
    @notifier ||= KissmetricsEventNotifier.new(client)
  end
end
