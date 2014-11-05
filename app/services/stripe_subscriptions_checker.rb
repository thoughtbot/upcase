class StripeSubscriptionsChecker
  def initialize(output:)
    @output = output
  end

  def check_all
    StripeCustomerCollection.new(per_page: 100).each do |customer|
      customer_with_subscription = CustomerWithSubscription.new(customer)
      if customer_with_subscription.has_out_of_sync_user?
        output.puts customer_with_subscription
      end
    end
  end

  private

  attr_reader :output
end
