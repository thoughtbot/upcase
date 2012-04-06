widget :daily_purchases_line do
  key "b54663118c0c565baedbccf11015e6a8f0f8b81e"
  type "line"
  data do
    {
      :items => (0..30).to_a.collect { |day| Purchase.where("created_at >= ? and created_at <= ?", day.days.ago.beginning_of_day, day.days.ago.end_of_day).all.sum(&:price) }.reverse,
      :x_axis => (0..30).to_a.collect { |day| day.days.ago.day.ordinalize }.reverse,
      :y_axis => [0, 2000],
      :colour => "989898"
    }
  end
end
