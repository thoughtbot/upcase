module TeamPlansHelper
  def team_price_per_month(plan)
    "starting at #{team_minimum_price(plan)} for #{team_minimum_people(plan)}"
  end

  def team_plan_quantity_select(form, purchase, plan)
    content_tag :li, team_plan_quantity_select_attributes(plan) do
      form.label(:quantity, 'Number of team members') +
        form.select(:quantity, options_for_team_quantity(purchase, plan))
    end
  end

  private

  def team_plan_quantity_select_attributes(plan)
    {
      :class => "string input required",
      :id => "purchase_quantity_input",
      "data-individual-price" => plan.individual_price
    }
  end

  def options_for_team_quantity(purchase, plan)
    options_for_select(
      (plan.minimum_quantity...50),
      selected_team_plan_quantity(purchase, plan)
    )
  end

  def selected_team_plan_quantity(purchase, plan)
    [purchase.quantity, plan.minimum_quantity].max
  end

  def team_minimum_price(plan)
    price_per_month(plan.individual_price * plan.minimum_quantity)
  end

  def team_minimum_people(plan)
    pluralize(plan.minimum_quantity, 'person')
  end
end
