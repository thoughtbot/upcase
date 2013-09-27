class TotalChurn
  attr_accessor :plans

  def initialize(plans)
    @plans = plans
  end

  def current
    total_weighted_churn / total_subscription_count.to_f
  end

  private

  def total_weighted_churn
    plans.sum { |plan| weighted_churn(plan) }
  end

  def weighted_churn(plan)
    plan.current_churn * plan.subscription_count
  end

  def total_subscription_count
    plans.sum { |plan| plan.subscription_count }
  end
end
