widget :daily_purchases do
  key "2019ad43df333537c31efef1ff7d73bfe8178240"
  type "number_and_secondary"
  data do
    {
      :value => Purchase.where("created_at >= ? and created_at <= ?", Date.today.beginning_of_day, Date.today.end_of_day).all.sum(&:price),
      :previous => Purchase.where("created_at >= ? and created_at <= ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day).all.sum(&:price)
    }
  end
end
