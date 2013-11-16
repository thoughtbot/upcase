class Widgets::ProjectedMonthlyRevenuesController < WidgetController
  def show
    respond_with money_widget(RevenueCalculator.new.projected_monthly_revenue)
  end
end
