class Widgets::PlanLtvsController < WidgetController
  def show
    respond_with number_widget(current_plan.current_ltv)
  end
end
