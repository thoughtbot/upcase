class SubscriptionMetrics
  def self.current_churn
    as_percentage(churn_for_last_30_days)
  end

  def self.previous_churn
    as_percentage(churn_between_60_and_30_days_ago)
  end

  def self.new_in_period(start_time, end_time)
    Purchase.for_purchaseable(Plan.default).
      within_range(start_time, end_time).count
  end

  def self.total_subscribers_as_of(time)
    active_as_of(time).where("created_at <= ?", time).count.to_f
  end

  def self.current_ltv
    average_selling_price * (1 / churn_for_last_30_days)
  end

  def self.previous_ltv
    average_selling_price * (1 / churn_between_60_and_30_days_ago)
  end

  private

  def self.churn_for_last_30_days
    canceled_in_last_30_days / count_30_days_ago
  end

  def self.churn_between_60_and_30_days_ago
    canceled_between_60_and_30_days_ago / count_60_days_ago
  end

  def self.canceled_in_last_30_days
    canceled_within_period(30.days.ago, Time.zone.now)
  end

  def self.count_30_days_ago
    total_subscribers_as_of(30.days.ago)
  end

  def self.canceled_between_60_and_30_days_ago
    canceled_within_period(60.days.ago, 30.days.ago)
  end

  def self.count_60_days_ago
    total_subscribers_as_of(60.days.ago)
  end

  def self.as_percentage(number)
    number * 100
  end

  def self.canceled_within_period(start_time, end_time)
    Subscription.paid.where("deactivated_on >= ? and deactivated_on <= ?", start_time, end_time).count.to_f
  end

  def self.active_as_of(time)
    Subscription.paid.where("deactivated_on is null OR deactivated_on > ?", time)
  end

  def self.average_selling_price
    99
  end
end
