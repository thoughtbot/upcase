widget :monthly_purchases do
  key "95e851c9cb7bc060cfae00f60c379315918e0a48"
  type "number_and_secondary"
  data do
    {
      value: Purchase.total_sales_within_range(30.days.ago, Time.zone.now),
      previous: Purchase.total_sales_within_range(60.days.ago, 30.days.ago),
      prefix: "$"
    }
  end
end
