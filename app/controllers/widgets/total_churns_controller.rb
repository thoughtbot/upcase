class Widgets::TotalChurnsController < WidgetController
  def show
    current_churn = TotalChurn.new(PlanFinder.all).current

    respond_with number_widget(current_churn)
  end
end
