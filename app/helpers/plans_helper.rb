module PlansHelper
  def plan_price(plan)
    "#{formatted_price(plan.price_in_dollars)} / #{plan_interval(plan)}"
  end

  def formatted_price(price)
    number_to_currency(price, precision: 0)
  end

  def plan_interval(plan)
    if plan.annual?
      "year"
    else
      "month"
    end
  end

  def grid_partial_for(plan)
    "plans/#{plan.sku.underscore}"
  end

  def professional_checkout_path
    new_checkout_path(plan: Plan::PROFESSIONAL_SKU)
  end

  def team_checkout_path
    new_checkout_path(plan: Plan::TEAM_SKU)
  end

  def large_check_image
    image_tag("pricing-check-lg.svg")
  end

  def check_image
    image_tag("pricing-check.svg")
  end

  def x_image
    image_tag("pricing-x.svg")
  end

  def professional(plan)
    if plan.professional?
      "professional"
    end
  end

  def marketable_user?
    !current_user.subscriber?
  end
end
