widget :total_new_subscriptions do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    { value: Metrics.new.subscription_signups_since(30.days.ago.to_date).count }
  end
end
