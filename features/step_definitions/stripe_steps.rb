Given 'stripe is stubbed with a failure' do
  FakeStripe.failure = true
end

Given 'I have an existing credit card' do
  User.all.each { |user| user.update_column(:stripe_customer_id, "test") }
  Stripe::Customer.stubs(:retrieve).returns({"active_card" => {"last4" => "1234", "type" => "Visa"}})
end

When 'I pay using Stripe' do
  page.execute_script <<-JS
    var form$ = $("#new_purchase");
    form$.append("<input type='hidden' name='purchase[stripe_token]' value='stripetoken' />");
  JS
  fill_in_name_and_email
  click_button 'Submit Payment'
end

When 'I pay with existing credit card' do
  find(:css, "input.use_existing_card").set(true)
  fill_in_name_and_email
  click_button 'Submit Payment'
end
