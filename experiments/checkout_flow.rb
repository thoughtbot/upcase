ab_test "Checkout flow" do
  description "Tests existing flow vs. new (GitHub OAuth only, Stripe  \
  Checkout, new landing)"
  alternatives :existing, :new
  metrics :signups
end
