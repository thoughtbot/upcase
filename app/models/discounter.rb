class Discounter
  def initialize(subscription:, discounted_plan:)
    @subscription = subscription
    @discounted_plan = discounted_plan
  end

  def switch_to_discounted_annual_plan
    @subscription.change_plan(sku: @discounted_plan.sku)
  end
end
