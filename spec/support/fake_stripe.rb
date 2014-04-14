require 'sinatra/base'
require 'capybara_discoball'

class FakeStripe < Sinatra::Base
  EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT = 'evt_1X6Z2OXmhBVcm9'
  EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER = 'evt_3X6Z2OXmhBVcm9'
  EVENT_ID_FOR_SUBSCRIPTION_DELETION = 'evt_2X6Z2OXmhBVcm9'
  CUSTOMER_ID = 'cus_1CXxPJDpw1VLvJ'
  CUSTOMER_EMAIL = 'foo@bar.com'

  cattr_reader :last_charge, :last_customer_email, :last_token, :coupons,
    :customer_plan_id, :last_coupon_used, :customer_plan_quantity
  cattr_accessor :failure

  get '/v1/tokens' do
    content_type 'application/javascript'

    "#{params[:callback]}(#{token.to_json}, 201)"
  end

  get '/v1/plans/:id' do
    content_type :json

    {
      interval: "month",
      name: "Prime",
      amount: 9900,
      currency: "usd",
      id: params[:id],
      object: "plan",
      livemode: false,
      interval_count: 1,
      trial_period_days: nil
    }.to_json
  end

  get '/v1/customers/:id' do
    content_type :json

    {
      object: "customer",
      created: 1359583041,
      id: CUSTOMER_ID,
      livemode: false,
      description: nil,
      email: CUSTOMER_EMAIL,
      delinquent: false,
      discount: nil,
      account_balance: 0,
      subscription: customer_subscription,
      active_card: {
        last4: '1234',
        type: 'Visa'
      }
    }.to_json
  end

  post '/v1/customers/:id/subscription' do
    @@customer_plan_id = params[:plan]
    @@last_coupon_used = params[:coupon]
    @@customer_plan_quantity = params[:quantity]
    content_type :json

    customer_subscription.to_json
  end

  post '/v1/customers' do
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

  post '/v1/charges' do
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

  delete '/v1/customers/:id/subscription' do
    content_type :json
    customer_subscription.merge({
      id: params[:id],
      deleted: true
    }).to_json
  end

  get '/v1/charges' do
    content_type :json
    [charge].to_json
  end

  get '/v1/charges/:id' do
    content_type :json
    charge(params[:id]).to_json
  end

  post '/v1/charges/:id/refund' do
    content_type :json
    {
      id: params[:id],
      deleted: true
    }.to_json
  end

  post '/v1/customers/:id' do
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
    elsif params[:stripe_token].blank? && params[:card].blank?
      status 400
      {
        type: "invalid_request_error",
        message: "Empty string given for card."
      }
    else
      '{}'
    end
  end

  post '/v1/coupons' do
    @@coupons ||= {}
    @@coupons[params[:id]] = create_coupon_hash(params)
    content_type :json

    @@coupons[params[:id]].to_json
  end

  get '/v1/coupons/:id' do
    @@coupons ||= {}
    content_type :json

    if @@coupons[params[:id]]
      @@coupons[params[:id]].to_json
    else
      status 404
    end
  end

  get '/v1/invoices' do
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

  get '/v1/invoices/:id' do
    content_type :json

    case params[:id]
    when 'in_1s4JSgbcUaElzU'
      customer_invoice.to_json
    when 'in_3Eh5UIbuDVdhat'
      customer_invoice_with_discount_in_percent.to_json
    when 'in_3lNBWqTVMT9sFb'
      customer_unsubscribe_invoice.to_json
    end
  end

  get "/v1/events/#{EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT}" do
    content_type :json
    {
      id: EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT,
      type: "invoice.payment_succeeded",
      data: {
        object: customer_invoice
      }
    }.to_json
  end

  get "/v1/events/#{EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER}" do
    content_type :json
    {
      id: EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER,
      type: "invoice.payment_succeeded",
      data: {
        object: customer_unsubscribe_invoice
      }
    }.to_json
  end

  get "/v1/events/#{EVENT_ID_FOR_SUBSCRIPTION_DELETION}" do
    content_type :json
    {
      id: EVENT_ID_FOR_SUBSCRIPTION_DELETION,
      type: "customer.subscription.deleted",
      data: {
        object: customer_subscription
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
      times_redeemed: params[:times_redeemed],
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
      customer: CUSTOMER_ID
    }
  end

  def customer_invoice_with_discount_in_percent
    customer_invoice.merge(
      id: "in_3Eh5UIbuDVdhat",
      discount: {
        id: "di_3Eh51qD66WOIHs",
        coupon: {
          id: "RESOLVE2014",
          percent_off: 100,
          amount_off: nil,
          currency: nil,
          object: "coupon",
          livemode: true,
          duration: "once",
          redeem_by: 1389225599,
          max_redemptions: nil,
          times_redeemed: 77,
          duration_in_months: nil,
          valid: true
        },
        start: 1388677692,
        object: "discount",
        customer: CUSTOMER_ID,
        end: nil
      },
      total: 0,
      subtotal: 9900,
      amount_due: 0
    )
  end

  def customer_unsubscribe_invoice
    {
      date: 1369159688,
      id: 'in_3lNBWqTVMT9sFb',
      period_start: 1366567645,
      period_end: 1369159645,
      lines: {
        invoiceitems: [
          {
            object: 'invoiceitem',
            id: 'ii_3XgI5MRjNLJsqj',
            date: 1393056868,
            amount: 9876,
            livemode: true,
            proration: true,
            currency: 'usd',
            customer: CUSTOMER_ID,
            description: 'Remaining time on Prime Workshops after 22 Feb 2014',
            metadata: {},
            invoice: 'in_3lNBWqTVMT9sFb',
            subscription: 'sub_3Xehu54zpkQS1b',
          },
          {
            object: 'invoiceitem',
            id: 'ii_3XgIlCOcNHW6pT',
            date: 1393056868,
            amount: -2893,
            livemode: true,
            proration: true,
            currency: 'usd',
            customer: CUSTOMER_ID,
            description: 'Unused time on Prime Basic after 22 Feb 2014',
            metadata: {},
            invoice: 'in_3lNBWqTVMT9sFb',
            subscription: 'sub_3Xehu54zpkQS1b',
          },
        ],
        prorations: [],
        subscriptions: [],
      },
      discount: nil,
      customer: CUSTOMER_ID,
      paid: true,
      subtotal: 6983,
      total: 6983,
      amount_due: 6983,
    }
  end

  def customer_subscription
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
    }
  end

  def charge(charge_id = 'charge_id')
    {
      failure_message: nil,
      description: nil,
      created: 1336671705,
      paid: true,
      currency: 'usd',
      amount: 1500,
      fee: 0,
      object: 'charge',
      refunded: false,
      card: {
        exp_year: 2015,
        type: 'Visa',
        address_zip: '94301',
        fingerprint: 'qhjxpr7DiCdFYTlH',
        address_line1: '522 Ramona St',
        last4: '4242',
        address_line2: 'Palo Alto',
        cvc_check: 'pass',
        object: 'card',
        address_country: 'USA',
        country: 'US',
        address_zip_check: 'pass',
        name: 'Java Bindings Cardholder',
        address_state: 'CA',
        exp_month: 12,
        id: 'cc_7qBiSeyivjSSjR',
        address_line1_check: 'pass' },
      customer: nil,
      amount_refunded: 0,
      id: charge_id,
      disputed: false,
      invoice: nil,
      livemode: false
    }
  end

  def token
    {
      id: "tok_2Z5RT715my6jQ7",
      livemode: false,
      created: 1379081368,
      used: false,
      object: "token",
      type: "card",
      card: {
        id: "card_2NCtCAVwvnMUUs",
        object: "card",
        last4: "4242",
        type: "Visa",
        exp_month: 3,
        exp_year: 2014,
        fingerprint: "61N1s4XuvJOoLAnb",
        customer: CUSTOMER_ID,
        country: "US",
        name: nil,
        address_line1: nil,
        address_line2: nil,
        address_city: nil,
        address_state: nil,
        address_zip: nil,
        address_country: nil
      }
    }
  end
end

FakeStripeRunner = Capybara::Discoball::Runner.new(FakeStripe) do |server|
  url = "http://#{server.host}:#{server.port}"
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
