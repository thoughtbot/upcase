class Widgets::TotalSubscriberCountsController < WidgetController
  def show
    respond_with number_widget(PlanFinder.all.sum(&:subscription_count))
  end
end
