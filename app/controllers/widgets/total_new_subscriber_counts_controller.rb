class Widgets::TotalNewSubscriberCountsController < WidgetController
  def show
    respond_with number_widget(new_subscribers)
  end

  private

  def new_subscribers
    Metrics.new.subscription_signups_since(30.days.ago.to_date).count
  end
end
