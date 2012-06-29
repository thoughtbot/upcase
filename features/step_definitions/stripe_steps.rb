Given 'stripe is stubbed with a failure' do
  FakeStripe.failure = true
end

When 'I pay using Stripe' do
  page.execute_script <<-JS
    var form$ = $("#new_purchase");
    form$.append("<input type='hidden' name='purchase[stripe_token]' value='stripetoken' />");
  JS
  fill_in_name_and_email
  click_button 'Submit Payment'
end
