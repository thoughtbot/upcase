widget :daily_purchases do
  key "2019ad43df333537c31efef1ff7d73bfe8178240"
  type "number_and_secondary"
  data do
    {
      value: Purchase.total_sales_within_range(1.day.ago, Time.zone.now),
      previous: Purchase.total_sales_within_range(2.days.ago, 1.day.ago),
      prefix: "$"
    }
  end
end
