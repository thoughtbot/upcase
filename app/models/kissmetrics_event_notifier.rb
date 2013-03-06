class KissmetricsEventNotifier
  def initialize(kissmetrics_client=KissmetricsClientFactory.client)
    @client = kissmetrics_client
  end

  def notify_of_purchase(purchase)
    if purchase.paid?
      if purchase.subscription?
        notify_of_subscription_sign_up(purchase)
      else
        notify_of_product_purchase(purchase.email, purchase.purchaseable_name, purchase.price)
      end
    end
  end

  def notify_of_subscription_billing(email, subscription_billing_amount)
    Rails.logger.info "Notifying Kissmetrics of subscription billing of $#{subscription_billing_amount} for #{email}"

    @client.record(email,
      'Subscription Billed',
      { 'Subscription Billing Amount' => subscription_billing_amount })
  end

  private

  def notify_of_product_purchase(email, product_name, price)
    Rails.logger.info "Notifying Kissmetrics of product purchase of #{product_name} by #{email}"

    @client.record(email,
      'Billed',
      { 'Product Name' => product_name, 'Amount Billed' => price })
  end

  def notify_of_subscription_sign_up(purchase)
    Rails.logger.info "Notifying Kissmetrics of subscription signup for Purchase with ID: #{purchase.id}"

    @client.record(purchase.email,
      'Signed Up',
      { 'Plan Name' => purchase.purchaseable_sku })
  end
end
