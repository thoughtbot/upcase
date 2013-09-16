module PlansHelper
  def price_per_month(plan)
    "#{number_to_currency(plan.individual_price, precision: 0)}/month"
  end
end
