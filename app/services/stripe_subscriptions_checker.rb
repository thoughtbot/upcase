class StripeSubscriptionsChecker
  def initialize(output:)
    @output = output
  end

  def check_all
    each_customer do |customer|
      if customer.has_out_of_sync_user?
        output.puts customer
      end
    end
  end

  private

  attr_reader :output

  def each_customer
    StripeCustomerCollection.new(per_page: 100).each do |customer|
      yield SubscriptionChecker.new(customer)
    end
  end
end
