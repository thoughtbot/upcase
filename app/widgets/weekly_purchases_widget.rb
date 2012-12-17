widget :weekly_purchases do
  key "2019ad43df333537c31efef1ff7d73bfe8178240"
  type "number_and_secondary"
  data do
    {
      value: Purchase.from_period(7.days.ago, Time.now),
      previous: Purchase.from_period(14.days.ago, 7.days.ago),
      prefix: "$"
    }
  end
end
