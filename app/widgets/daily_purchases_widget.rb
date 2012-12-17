widget :daily_purchases do
  key "2019ad43df333537c31efef1ff7d73bfe8178240"
  type "number_and_secondary"
  data do
    {
      value: Purchase.from_period(1.day.ago, Time.now),
      previous: Purchase.from_period(2.days.ago, 1.day.ago),
      prefix: "$"
    }
  end
end
