module PlansHelper
  def individual_price_per_month(plan)
    price_per_month(plan.individual_price)
  end

  def price_per_month(price)
    "#{number_to_currency(price, precision: 0)}/month"
  end
end
