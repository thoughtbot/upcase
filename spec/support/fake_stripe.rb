require 'sinatra/base'
require 'capybara_discoball'

class FakeStripe < Sinatra::Base
  EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT = 'evt_1X6Z2OXmhBVcm9'
  CUSTOMER_ID = 'cus_1CXxPJDpw1VLvJ'
  CUSTOMER_EMAIL = 'foo@bar.com'

  cattr_reader :last_charge, :last_customer_email, :last_token, :coupons
  cattr_accessor :failure

  get '/customers/*' do
    content_type :json

    {
      object: "customer",
      created: 1359583041,
      id: CUSTOMER_ID,
      livemode: false,
      description: nil,
      email: CUSTOMER_EMAIL,
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
      customer: CUSTOMER_ID,
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
        customer: CUSTOMER_ID,
        id: "di_N8U1hA4YzyRH9w" },
      account_balance: 0,
      email: nil,
      object: "customer",
      active_card: nil,
      subscription: nil,
      id: CUSTOMER_ID,
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

  delete '/customers/:id/subscription' do
    content_type :json
    {
      id: params[:id],
      deleted: true
    }.to_json
  end

  get '/charges/:id' do
    content_type :json
    { failure_message: nil,
      description: nil,
      created: 1336671705,
      paid: true,
      currency: "usd",
      amount: 1500,
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
      id: params[:id],
      disputed: false,
      invoice: nil,
      livemode: false
    }.to_json
  end

  post '/charges/:id/refund' do
    content_type :json
    {
      id: params[:id],
      deleted: true
    }.to_json
  end

  post '/customers/:id' do
    content_type :json
    if failure
      status 402
      {
        error: {
        message: "Your credit card was declined",
        type: "card_error",
        param: "number",
        code: "incorrect_number"
      }
      }.to_json
    else
      '{}'
    end
  end

  post '/coupons' do
    @@coupons ||= {}
    @@coupons[params[:id]] = create_coupon_hash(params)
    content_type :json

    @@coupons[params[:id]].to_json
  end

  get '/coupons/:id' do
    @@coupons ||= {}
    content_type :json

    if @@coupons[params[:id]]
      @@coupons[params[:id]].to_json
    else
      status 404
    end
  end

  get '/invoices' do
    content_type :json
    {
      object: "list",
      count: 1,
      url: "/v1/invoices",
      data: [
        customer_invoice
      ]
    }.to_json
  end

  get '/invoices/:id' do
    content_type :json
    customer_invoice.to_json
  end

  get "/events/#{EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT}" do
    content_type :json
    {
      id: "evt_1X6Z2OXmhBVcm9",
      type: "invoice.payment_succeeded",
      data: {
        object: {
          customer: CUSTOMER_ID,
          lines: {
            subscriptions: [
              {
                plan: {
                  interval: "month",
                  name: "Prime",
                  amount: 9900,
                  currency: "usd",
                  id: "prime",
                  object: "plan",
                }
              }
            ]
          }
        }
      }
    }.to_json
  end

  def create_coupon_hash(params)
    {
      id: params[:id],
      percent_off: params[:percent_off],
      amount_off: params[:amount_off],
      currency: params[:currency],
      object: "coupon",
      livemode: false,
      duration: params[:duration],
      redeem_by: params[:redeem_by],
      max_redemptions: params[:max_redemptions],
      times_redeemed: 0,
      duration_in_months: params[:duration_in_months]
    }
  end

  def customer_invoice
    {
      date: 1369159688,
      id: "in_1s4JSgbcUaElzU",
      period_start: 1366567645,
      period_end: 1369159645,
      lines: {
        invoiceitems: [],
        prorations: [],
        subscriptions: [
          {
            id: "su_1ri03Utwow0Sue",
            object: "line_item",
            type: "subscription",
            livemode: true,
            amount: 9900,
            currency: "usd",
            proration: false,
            period: {
              start: 1371755084,
              end: 1374347084
            },
            quantity: 1,
            plan: {
              interval: "month",
              name: "Prime",
              amount: 9900,
              currency: "usd",
              id: "prime",
              object: "plan",
              livemode: false,
              interval_count: 1,
              trial_period_days: nil
            },
            description: nil
          }
        ]
      },
      discount: {
        id: "di_1m6sZ5I9P0fk8d",
        coupon: {
          id: "railsconf",
          percent_off: nil,
          amount_off: 2000,
          currency: "usd",
          object: "coupon",
          livemode: true,
          duration: "once",
          redeem_by: 1367971199,
          max_redemptions: nil,
          times_redeemed: 1,
          duration_in_months:nil
        }
      },
      paid: true,
      total: 7900,
      subtotal: 9900,
      amount_due: 7900,
      customer: "cus_1KjDojUy0RiwFH"
    }
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
