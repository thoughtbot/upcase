module FulfillmentStubs
  def stub_subscription_fulfillment(checkout, user = checkout.user)
    stub('fulfillment', fulfill: true, remove: true).tap do |fulfillment|
      SubscriptionFulfillment.
        stubs(:new).
        with(user, checkout.subscribeable).
        returns(fulfillment)
    end
  end
end

RSpec.configure do |config|
  config.include FulfillmentStubs, type: :model
end
