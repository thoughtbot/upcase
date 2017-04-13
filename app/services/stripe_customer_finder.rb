class StripeCustomerFinder
  SIMILAR_OBJECT_ERROR = "a similar object exists in live mode".freeze
  NO_CUSTOMER_ERROR = "No such customer".freeze

  def self.retrieve(customer_id)
    new.retrieve(customer_id)
  end

  def retrieve(customer_id)
    Stripe::Customer.retrieve(customer_id)
  rescue Stripe::InvalidRequestError => e
    if dev? && has_whitelisted_error?(e)
      generate_fake_customer(customer_id)
    else
      raise
    end
  end

  private

  def dev?
    Rails.env.development?
  end

  def has_whitelisted_error?(error)
    error.message.include?(SIMILAR_OBJECT_ERROR) ||
      error.message.include?(NO_CUSTOMER_ERROR)
  end

  def generate_fake_customer(customer_id)
    Stripe::Customer.construct_from(
      "id" => customer_id.to_s,
      "object" => "customer",
      "default_card" => "card_12345",
      "default_source" => "card_12345",
      "subscriptions" => [Stripe::Subscription.construct_from(
          "current_period_end" => 1.month.from_now
      )],
      "cards" => Stripe::ListObject.construct_from(
        "data" => [Stripe::Card.construct_from(
          "id" => "card_12345",
          "object" => "card",
          "address_city" => nil,
          "address_country" => nil,
          "address_line1" => nil,
          "address_line1_check" => nil,
          "address_line2" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_zip_check" => nil,
          "brand" => "FakeVisa",
          "country" => "US",
          "customer" => customer_id.to_s,
          "cvc_check" => "pass",
          "dynamic_last4" => nil,
          "exp_month" => 1,
          "exp_year" => 2100,
          "fingerprint" => "61N1s4XuvJOoLAnb",
          "funding" => "credit",
          "last4" => "4242",
          "metadata" => {},
          "name" => nil,
          "tokenization_method" => nil,
        )],
        "has_more" => false,
        "total_count" => 1,
        "url" => "/v1/customers/cus_12345/cards",
      ),
    )
  end
end
