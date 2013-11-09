module PaypalHelpers
  def pay_using_paypal
    uri = URI.parse(current_url)
    Payments::PaypalPayment.host = "#{uri.host}:#{uri.port}"
    choose 'purchase_payment_method_paypal'
    fill_in_name_and_email
    click_button 'Proceed to Checkout'
    click_button 'Pay using Paypal'
  end
end
