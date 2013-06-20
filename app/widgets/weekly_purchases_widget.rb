widget :weekly_purchases do
  key "2019ad43df333537c31efef1ff7d73bfe8178240"
  type "number_and_secondary"
  data do
    {
      value: Purchase.total_sales_within_range(7.days.ago, Time.zone.now),
      previous: Purchase.total_sales_within_range(14.days.ago, 7.days.ago),
      prefix: "$"
    }
  end
end
