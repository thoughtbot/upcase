class MailchimpFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    MailchimpFulfillmentJob.enqueue(sku, email)
  end

  def remove
    MailchimpRemovalJob.enqueue(sku, email)
  end

  private

  def sku
    purchaseable.sku
  end

  def purchaseable
    @purchase.purchaseable
  end

  def email
    @purchase.email
  end
end
