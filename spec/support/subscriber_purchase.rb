def create_subscriber_purchase(type, user = nil)
  purchaseable = create(type)
  create_subscriber_purchase_from_purchaseable(purchaseable, user)
end

def create_subscriber_purchase_from_purchaseable(purchaseable, user = nil)
  user ||= create(:user)
  subscriber_purchase = SubscriberPurchase.new(purchaseable, user)
  subscriber_purchase.create
end
