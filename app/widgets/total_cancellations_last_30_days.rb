widget :total_cancellations_last_30_days do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    { value: Metrics.new.canceled_subscriptions_since(30.days.ago.to_date).count }
  end
end
