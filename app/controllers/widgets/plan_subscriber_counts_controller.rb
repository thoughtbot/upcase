class Widgets::PlanSubscriberCountsController < WidgetController
  def show
    respond_with number_widget(current_plan.subscription_count)
  end
end
