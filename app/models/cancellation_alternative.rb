class CancellationAlternative
  def initialize(current_plan:, discounted_plan:)
    @current_plan = current_plan
    @discounted_plan = discounted_plan
  end

  def can_switch_to_discounted_plan?
    @current_plan != @discounted_plan
  end

  def discount_percentage_vs_current_plan_annualized
    discount_percentage_for(
      new_price: discount_plan_price,
      current_price: current_annual_price_in_dollars
    )
  end

  def discount_plan_price
    @discounted_plan.price_in_dollars
  end

  private

  def discount_percentage_for(new_price:, current_price:)
    ((1 - (new_price / current_price)) * 100).round(0)
  end

  def current_annual_price_in_dollars
    @current_plan.price_in_dollars * 12.0
  end
end
