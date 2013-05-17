class SubscriptionMetrics
  def self.current_churn
    as_percentage(canceled_in_last_30_days / count_30_days_ago)
  end

  def self.previous_churn
    as_percentage(canceled_between_60_and_30_days_ago / count_60_days_ago)
  end

  private

  def self.canceled_in_last_30_days
    canceled_within_period(30.days.ago, Time.now)
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
    Subscription.where("deactivated_on >= ? and deactivated_on <= ?", start_time, end_time).count.to_f
  end

  def self.total_subscribers_as_of(time)
    Subscription.where("created_at <= ?", time).count.to_f
  end
end
