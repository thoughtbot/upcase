RSpec::Matchers.define :have_active_stripe_subscription do |plan|
  match do |stripe_customer|
    stripe_customer.create_options[:plan] = plan.sku
  end
end
