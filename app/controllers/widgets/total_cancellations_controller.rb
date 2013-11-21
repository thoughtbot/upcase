class Widgets::TotalCancellationsController < WidgetController
  def show
    respond_with number_widget(total_cancellations)
  end

  private

  def total_cancellations
    Metrics.new.canceled_subscriptions_since(30.days.ago)
  end

end
