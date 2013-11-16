class RevenueCalculator
  def projected_monthly_revenue
    PlanFinder.all.sum(&:projected_monthly_revenue)
  end
end
