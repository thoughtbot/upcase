class SubscriptionCountReport
  CSV_HEADER = %w(date count)

  attr_reader :rows

  def initialize
    calculate_subscriber_counts
  end

  def report_name
    "subscriber_counts"
  end

  private

  def calculate_subscriber_counts
    @rows = (start_date..end_date).map do |date|
      active_subscribers = Subscription.where('created_at <= ?', date + 1).
        where('deactivated_on IS NULL OR deactivated_on > ?', date).count
      [date.to_s, active_subscribers.to_s]
    end.unshift csv_header
  end

  def start_date
    Subscription.order('created_at').first.created_at.to_date
  end

  def end_date
    Date.today
  end

  def csv_header
    CSV_HEADER
  end

end
