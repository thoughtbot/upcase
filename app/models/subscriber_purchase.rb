# Handles the special-casing necessary to create Purchases for Subscribers without charging them.

class SubscriberPurchase
  def initialize(purchaseable, subscriber, comments = nil)
    @purchaseable = purchaseable
    @subscriber = subscriber
    @comments = comments
  end

  def create
    create_purchase_record
  end

  private

  def create_purchase_record
    purchase = Purchase.new
    purchase.variant = 'individual'
    purchase.payment_method = 'subscription'
    purchase.paid_price = 0
    purchase.purchaseable = @purchaseable
    purchase.name = @subscriber.name
    purchase.email = @subscriber.email
    purchase.github_usernames = [@subscriber.github_username]
    purchase.user = @subscriber
    purchase.comments = @comments
    purchase.save!
    @purchase = purchase
  end
end
