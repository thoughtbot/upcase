class Widgets::PlanChurnsController < WidgetController
  def show
    respond_with number_widget(current_plan.current_churn)
  end
end
