module PlansHelper
  def plan_price(plan)
    "#{formatted_price(plan.price)} / #{plan_interval(plan)}"
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

  def formatted_name(plan)
    first_line, _, last_line = plan.name.rpartition(" ")
    [first_line, last_line].join("<br/>").html_safe
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

  def popular(plan)
    if plan.popular?
      "popular"
    end
  end
end
