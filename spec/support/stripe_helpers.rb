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

  def pay_using_stripe_with_existing_card
    find(:css, "input.use_existing_card").set(true)
    click_button 'Submit Payment'
  end

  def stub_stripe_to_fail
    FakeStripe.failure = true
  end

  def create_amount_stripe_coupon(id, duration, amount_off)
    Stripe::Coupon.create(id: id, duration: duration, amount_off: amount_off)
  end

  def create_recurring_stripe_coupon(id, duration, amount_off)
    Stripe::Coupon.create(
      id: id,
      duration: 'repeating',
      duration_in_months: duration,
      amount_off: amount_off
    )
  end

  def create_percentage_off_stripe_coupon(id, duration, percent_off)
    Stripe::Coupon.create(id: id, duration: duration, percent_off: percent_off)
  end
end
