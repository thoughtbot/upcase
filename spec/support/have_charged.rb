RSpec::Matchers.define :have_charged do |amount|
  chain :to do |email|
    @email = email
  end

  chain :with_token do |stripe_token|
    @stripe_token = stripe_token
  end

  match do |fake_stripe|
    fake_stripe.last_charge.to_i == amount &&
      fake_stripe.last_customer_email == @email &&
      fake_stripe.last_token == @stripe_token
  end
end
