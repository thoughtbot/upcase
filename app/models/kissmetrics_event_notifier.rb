class KissmetricsEventNotifier
  def initialize(kissmetrics_client=KissmetricsClientFactory.client)
    @client = kissmetrics_client
  end

  def notify_of(purchase)
    if purchase.paid?
      notify_of_billing_event(purchase)

      if purchase.subscription?
        notify_of_subscription_sign_up(purchase)
      end
    end
  end

  private

  def notify_of_billing_event(purchase)
    @client.record(purchase.email,
      'Billed',
      { 'Product Name' => purchase.purchaseable_name, 'Amount Billed' => purchase.price })
  end

  def notify_of_subscription_sign_up(purchase)
    @client.record(purchase.email,
      'Signed Up',
      { 'Plan Name' => purchase.purchaseable_sku })
  end
end
