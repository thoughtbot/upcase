widget :daily_purchases do
  key "2019ad43df333537c31efef1ff7d73bfe8178240"
  type "number_and_secondary"
  data do
    {
      :value => Purchase.from_day(Date.today),
      :previous => Purchase.from_day(Date.yesterday),
      :prefix => "$"
    }
  end
end
