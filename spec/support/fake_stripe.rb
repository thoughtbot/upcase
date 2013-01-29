require 'sinatra/base'
require 'capybara_discoball'

class FakeStripe < Sinatra::Base
  cattr_reader :last_charge, :last_customer_email, :last_token
  cattr_accessor :failure

  get '/customers/*' do
    content_type :json

    {
      object: "customer",
      created: 1359583041,
      id: "cus_1CXxPJDpw1VLvJ",
      livemode: false,
      description: nil,
      email: nil,
      delinquent: false,
      subscription: nil,
      discount: nil,
      account_balance: 0
    }.to_json
  end

  post '/customers/*/subscription' do
    content_type :json

    {
      plan: {
        interval: 'month',
        name: 'Java Bindings Plan',
        amount: 100,
        currency: 'usd',
        id: 'JAVA-PLAN-1b3a5c51-5c1a-421b-8822-69138c2d937b',
        object: 'plan',
        livemode: false,
        interval_count: 1,
        trial_period_days: nil
      },
      object: 'subscription',
      start: 1358555835,
      status: 'active',
      customer: 'cus_1CXxPJDpw1VLvJ',
      cancel_at_period_end: false,
      current_period_start: 1358555835,
      current_period_end: 1361234235,
      ended_at: nil,
      trial_start: nil,
      trial_end: nil,
      canceled_at: nil,
      quantity: 1
    }.to_json
  end

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
        customer: "cus_1CXxPJDpw1VLvJ",
        id: "di_N8U1hA4YzyRH9w" },
      account_balance: 0,
      email: nil,
      object: "customer",
      active_card: nil,
      subscription: nil,
      id: "cus_1CXxPJDpw1VLvJ",
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

FakeStripeRunner = Capybara::Discoball::Runner.new(FakeStripe) do |server|
  url = server.url('')
  Stripe.api_base = url
end

module FakeStripeFailureStatus
  def ensure_fake_stripe_failure_status_is_reset
    fake_stripe_failure = FakeStripe.failure
    begin
      yield
    ensure
      FakeStripe.failure = fake_stripe_failure
    end
  end
end

RSpec.configure do |config|
  config.include FakeStripeFailureStatus

  config.around do |example|
    ensure_fake_stripe_failure_status_is_reset do
      example.run
    end
  end
end
