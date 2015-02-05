module FulfillmentStubs
  def stub_subscription_fulfillment(checkout, user = checkout.user)
    double("fulfillment", fulfill: true, remove: true).tap do |fulfillment|
      allow(SubscriptionFulfillment).to receive(:new).
        with(user, checkout.plan).
        and_return(fulfillment)
    end
  end
end

RSpec.configure do |config|
  config.include FulfillmentStubs, type: :model
end
