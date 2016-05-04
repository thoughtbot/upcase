class FakeStripeCustomer
  attr_reader :subscriptions_called, :create_called, :create_options

  def subscriptions
    @subscriptions_called = true
    self
  end

  def create(options)
    @create_options = options
    @create_called = true
    OpenStruct.new(id: options[:plan])
  end

  def cards
    [Stripe::Card.construct_from(
      "id" => "card_12345",
      "object" => "card",
      "brand" => "FakeVisa",
      "customer" => "cus_123",
      "cvc_check" => "pass",
      "exp_month" => 1,
      "exp_year" => 2100,
      "last4" => "4242",
    )]
  end
end
