module PlanWithCountableSubscriptions
  def subscription_count
    active_paid_subscriptions.count
  end

  def subscription_count_30_days_ago
    paid_subscriptions.
      active_as_of(30.days.ago).
      created_before(30.days.ago).
      count.
      to_f
  end

  def current_churn
    as_percent(churn_for_last_30_days)
  end

  def current_ltv
    individual_price * (1 / churn_for_last_30_days)
  end

  private

  def churn_for_last_30_days
    if subscription_count_30_days_ago.zero?
      0
    else
      canceled_in_last_30_days_count / subscription_count_30_days_ago
    end
  end

  def active_paid_subscriptions
    paid_subscriptions.active
  end

  def paid_subscriptions
    subscriptions.paid
  end

  def canceled_in_last_30_days_count
    paid_subscriptions.canceled_in_last_30_days.count
  end

  def as_percent(number)
    number * 100
  end
end
