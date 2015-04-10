class CancellationAlternative
  def initialize(current_plan:, discounted_plan:)
    @current_plan = current_plan
    @discounted_plan = discounted_plan
  end

  def can_switch_to_discounted_plan?
    @current_plan != @discounted_plan
  end

  def discount_percentage_vs_current_plan_annualized
    ((1 - (@discounted_plan.price_in_dollars / (@current_plan.price_in_dollars * 12.0))) * 100).
      round(0)
  end

  def discount_plan_price
    @discounted_plan.price_in_dollars
  end
end
