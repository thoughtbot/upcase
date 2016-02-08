module TeamPlansHelper
  def team_plan_quantity_select(form, checkout, plan)
    content_tag :li, team_plan_quantity_select_attributes(plan) do
      form.label(:quantity, 'Number of team members') +
        form.select(:quantity, options_for_team_quantity(checkout, plan))
    end
  end

  def team_page?
    @team_page.present?
  end

  private

  def team_plan_quantity_select_attributes(plan)
    {
      :class => "string input required",
      :id => "checkout_quantity_input",
      "data-price" => plan.price_in_dollars,
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
end
