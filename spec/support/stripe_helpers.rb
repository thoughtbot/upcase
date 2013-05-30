module StripeHelpers
  def pay_using_stripe
    page.execute_script <<-JS
      var form$ = $("#new_purchase");
      form$.append("<input type='hidden' name='purchase[stripe_token]' value='stripetoken' />");
    JS
    fill_in 'Name', with: 'Ben'
    fill_in 'Email', with: 'ben@thoughtbot.com'
    click_button 'Submit Payment'
  end
end
