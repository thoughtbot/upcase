module FulfillmentStubs
  def stub_subscription_fulfillment(purchase, user = purchase.user)
    stub('fulfillment', fulfill: true, remove: true).tap do |fulfillment|
      SubscriptionFulfillment.
        stubs(:new).
        with(user, purchase.purchaseable).
        returns(fulfillment)
    end
  end
end

RSpec.configure do |config|
  config.include FulfillmentStubs, type: :model
end
