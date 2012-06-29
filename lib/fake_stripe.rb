require 'sinatra/base'
require 'capybara_server_runner'

class FakeStripe < Sinatra::Base
  cattr_reader :last_charge, :last_customer_email, :last_token
  cattr_accessor :failure

  post '/customers' do
    @@last_customer_email = params[:email]
    @@last_token = params[:card]
    content_type :json

    if failure
      status 402
      { type:"card_error", message: "card declined"}.to_json
    else
      { description: nil,
        delinquent: false,
        created: 1336671710,
        discount: {
          coupon: {
            redeem_by: nil,
            percent_off: 10,
            times_redeemed: 1,
            object: "coupon",
            max_redemptions: nil,
            duration_in_months: nil,
            duration: "once",
            id: "JAVA-COUPON-55529463-58ac-4bc0-ac3f-cb981fa4c82c",
            livemode: false },
        end: 1339350110,
        start: 1336671710,
        object: "discount",
        customer: "cus_tCyokvUtZubs7s",
        id: "di_N8U1hA4YzyRH9w" },
      account_balance: 0,
      email: nil,
      object: "customer",
      active_card: nil,
      subscription: nil,
      id: "cus_tCyokvUtZubs7s",
      livemode: false }.to_json
    end
  end

  post '/charges' do
    @@last_charge = params[:amount]
    content_type :json

    { failure_message: nil,
      description: nil,
      created: 1336671705,
      paid: true,
      currency: "usd",
      amount: params[:amount],
      fee: 0,
      object: "charge",
      refunded: false,
      card: {
        exp_year: 2015,
        type: "Visa",
        address_zip: "94301",
        fingerprint: "qhjxpr7DiCdFYTlH",
        address_line1: "522 Ramona St",
        last4: "4242",
        address_line2: "Palo Alto",
        cvc_check: "pass",
        object: "card",
        address_country: "USA",
        country: "US",
        address_zip_check: "pass",
        name: "Java Bindings Cardholder",
        address_state: "CA",
        exp_month: 12,
        id: "cc_7qBiSeyivjSSjR",
        address_line1_check: "pass" },
      customer: nil,
      amount_refunded: 0,
      id: "ch_JQhSfU9Rz21owt",
      disputed: false,
      invoice: nil,
      livemode: false 
    }.to_json
  end
end

FakeStripeRunner = CapybaraServerRunner.new(FakeStripe) do |server|
  url = server.url('')
  Stripe.api_base = url
end
