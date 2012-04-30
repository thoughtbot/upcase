widget :daily_purchases_line do
  key "b54663118c0c565baedbccf11015e6a8f0f8b81e"
  type "line"
  data do
    items = Purchase.last_30_days
    {
      :items => items,
      :x_axis => (0..30).to_a.collect { |day| day.days.ago.day }.reverse,
      :y_axis => [items.min, items.max],
      :colour => "989898"
    }
  end
end
