module TeamPlansHelper
  def team_price_per_month(plan)
    "starting at #{minimum_team_price(plan)} for #{minimum_team_people(plan)}"
  end

  def team_plan_quantity_select(form, checkout, plan)
    content_tag :li, team_plan_quantity_select_attributes(plan) do
      form.label(:quantity, 'Number of team members') +
        form.select(:quantity, options_for_team_quantity(checkout, plan))
    end
  end

  private

  def team_plan_quantity_select_attributes(plan)
    {
      :class => "string input required",
      :id => "checkout_quantity_input",
      "data-individual-price" => plan.individual_price,
      "data-interval" => plan.subscription_interval
    }
  end

  def options_for_team_quantity(checkout, plan)
    options_for_select (plan.minimum_quantity...50),
                       selected_team_plan_quantity(checkout, plan)
  end

  def selected_team_plan_quantity(checkout, plan)
    [checkout.quantity, plan.minimum_quantity].max
  end

  def minimum_team_price(plan)
    price_per_month plan.minimum_team_price
  end

  def minimum_team_people(plan)
    pluralize(plan.minimum_quantity, 'person')
  end
end
