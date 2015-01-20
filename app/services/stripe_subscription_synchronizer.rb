class StripeSubscriptionSynchronizer
  def initialize(output)
    @output = output
  end

  def check_all
    stripe_customer_collection.each do |customer|
      customer_with_subscription = CustomerWithSubscription.new(customer)

      if customer_with_subscription.has_out_of_sync_user?
        @output.puts customer_with_subscription
      end
    end
  end

  def update_local_stripe_references
    stripe_customer_collection.each do |customer|
      CustomerWithSubscription.new(customer).update_subscription_stripe_id
    end
  end

  private

  def stripe_customer_collection
    StripeCustomerCollection.new(per_page: 100)
  end
end
