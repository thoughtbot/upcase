require "sinatra/base"
require "capybara_discoball"

class FakeStripe < Sinatra::Base
  EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT = "evt_1X6Z2OXmhBVcm9"
  EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER = "evt_3X6Z2OXmhBVcm9"
  EVENT_ID_FOR_SUBSCRIPTION_DELETION = "evt_2X6Z2OXmhBVcm9"
  CUSTOMER_ID = "cus_1CXxPJDpw1VLvJ"
  CUSTOMER_EMAIL = "foo@bar.com"
  SUBSCRIPTION_ID = "sub_4uJxAs8DlW3Z0w"
  PLAN_ID = "JAVA-PLAN-1b3a5c51-5c1a-421b-8822-69138c2d937b"

  cattr_reader :last_charge, :last_customer_email, :last_token, :coupons,
    :customer_plan_id, :last_coupon_used, :customer_plan_quantity
  cattr_accessor :coupons, :customer_ids, :failure

  def self.reset
    self.coupons = {}
    self.customer_ids = [CUSTOMER_ID]
    self.failure = nil
  end

  get "/v1/tokens" do
    content_type "application/javascript"

    "#{params[:callback]}(#{token.to_json}, 201)"
  end

  get "/v1/plans/:id" do
    content_type :json

    {
      interval: "month",
      name: "Upcase",
      created: 1408639724,
      amount: 9900,
      currency: "usd",
      id: params[:id],
      object: "plan",
      livemode: false,
      interval_count: 1,
      trial_period_days: nil,
      metadata: {},
      statement_description: nil
    }.to_json
  end

  get "/v1/customers/:id" do
    content_type :json

    customer(params[:id]).to_json
  end

  post "/v1/customers/:customer_id/subscriptions" do
    content_type :json
    customer_subscription.merge(
      id: params[:id],
      customer: params[:customer_id]
    ).to_json
  end

  post "/v1/customers/:customer_id/subscriptions/:id" do
    @@customer_plan_id = params[:plan]
    @@last_coupon_used = params[:coupon]
    @@customer_plan_quantity = params[:quantity]
    content_type :json

    if params[:plan].blank?
      status 400
      {
        type: "invalid_request_error",
        message: "Missing required param: plan"
      }.to_json
    else
      customer_subscription.merge(
        id: params[:id],
        customer: params[:customer_id]
      ).to_json
    end
  end

  get "/v1/customers" do
    content_type :json

    {
      "object" => "list",
      "url" => "v1/customers",
      "has_more" => false,
      "data" => paginate(
        collection: customer_ids.map { |customer_id| customer(customer_id) },
        starting_after: params[:starting_after],
        limit: (params[:limit] || 10).to_i
      )
    }.to_json
  end

  post "/v1/customers" do
    @@last_customer_email = params[:email]
    @@last_token = params[:card]
    content_type :json

    if failure
      status 402
      { type: "card_error", message: "card declined" }.to_json
    else
      {
        object: "customer",
        created: 1336671710,
        id: CUSTOMER_ID,
        livemode: false,
        description: CUSTOMER_EMAIL,
        email: CUSTOMER_EMAIL,
        delinquent: false,
        metadata: {},
        subscriptions: {
          object: "list",
          total_count: 1,
          has_more: false,
          url: "/v1/customers/#{CUSTOMER_ID}/subscriptions",
          data: [customer_subscription]
        },
        discount: {
          coupon: {
            id: "JAVA-COUPON-55529463-58ac-4bc0-ac3f-cb981fa4c82c",
            created: 1410384799,
            percent_off: 10,
            amount_off: nil,
            currency: "usd",
            object: "coupon",
            livemode: false,
            duration: "once",
            redeem_by: nil,
            max_redemptions: nil,
            times_redeemed: 1,
            duration_in_months: nil,
            valid: true,
            metadata: {}
          },
          start: 1336671710,
          object: "discount",
          customer: CUSTOMER_ID,
          subscription: nil,
          end: 1339350110
        },
        account_balance: 0,
        currency: "usd",
        cards: {
          object: "list",
          total_count: 1,
          has_more: false,
          url: "/v1/customers/#{CUSTOMER_ID}/cards",
          data: [card]
        },
        default_card: "card_2NCtCAVwvnMUUs"
      }.to_json
    end
  end

  post "/v1/charges" do
    @@last_charge = params[:amount]
    content_type :json

    {
      id: "ch_JQhSfU9Rz21owt",
      object: "charge",
      created: 1336671705,
      livemode: false,
      paid: true,
      amount: params[:amount],
      currency: "usd",
      refunded: false,
      card: {
        id: "cc_7qBiSeyivjSSjR",
        object: "card",
        last4: "4242",
        brand: "Visa",
        funding: "credit",
        exp_month: 12,
        exp_year: 2015,
        fingerprint: "qhjxpr7DiCdFYTlH",
        country: "US",
        name: "Java Bindings Cardholder",
        address_line1: "522 Ramona St",
        address_line2: "Palo Alto",
        address_city: nil,
        address_state: "CA",
        address_zip: "94301",
        address_country: "USA",
        cvc_check: "pass",
        address_line1_check: "pass",
        address_zip_check: "pass",
        customer: CUSTOMER_ID
      },
      captured: true,
      refunds: {
        object: "list",
        total_count: 0,
        has_more: false,
        url: "/v1/charges/ch_JQhSfU9Rz21owt/refunds",
        data: []
      },
      balance_transaction: "txn_2OMDmEVTgCgMmp",
      failure_message: nil,
      failure_code: nil,
      amount_refunded: 0,
      customer: CUSTOMER_ID,
      invoice: "in_1s4JSgbcUaElzU",
      description: nil,
      dispute: nil,
      metadata: {},
      statement_description: nil,
      receipt_email: nil,
      receipt_number: nil
    }.to_json
  end

  delete "/v1/customers/:customer_id/subscriptions/:id" do
    content_type :json
    if params[:at_period_end] == "true"
      customer_subscription.merge(
        id: params[:id],
        customer: params[:customer_id],
        status: "active",
        cancel_at_period_end: true
      ).to_json
    else
      customer_subscription.merge(
        id: params[:id],
        customer: params[:customer_id],
        status: "canceled",
      ).to_json
    end
  end

  get "/v1/charges" do
    content_type :json
    [charge].to_json
  end

  get "/v1/charges/:id" do
    content_type :json
    charge(params[:id]).to_json
  end

  post "/v1/charges/:id/refunds" do
    content_type :json
    {
      id: "re_3gOGZxTuX3KKJS",
      amount: 9900,
      currency: "usd",
      created: 1369159688,
      object: "refund",
      balance_transaction: "txn_2OMDmEVTgCgMmp",
      metadata: {},
      charge: params[:id],
      receipt_number: nil
    }.to_json
  end

  post "/v1/customers/:id" do
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
      customer.to_json
    end
  end

  post "/v1/coupons" do
    coupons[params[:id]] = create_coupon_hash(params)
    content_type :json

    coupons[params[:id]].to_json
  end

  get "/v1/coupons/:id" do
    content_type :json

    if coupons[params[:id]]
      coupons[params[:id]].to_json
    else
      status 404
      {
        error: {
          type: "invalid_request_error",
          message: "No such coupon: #{params[:id]}",
          param: "id"
        }
      }.to_json
    end
  end

  get "/v1/invoices" do
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

  get "/v1/invoices/upcoming" do
    content_type :json

    customer_invoice.to_json
  end

  get "/v1/invoices/:id" do
    content_type :json

    case params[:id]
    when "in_1s4JSgbcUaElzU"
      customer_invoice.to_json
    when "in_3Eh5UIbuDVdhat"
      customer_invoice_with_discount_in_percent.to_json
    when "in_3lNBWqTVMT9sFb"
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
      created: 1403972754,
      percent_off: params[:percent_off],
      amount_off: params[:amount_off],
      currency: params[:currency],
      object: "coupon",
      livemode: false,
      duration: params[:duration],
      redeem_by: params[:redeem_by],
      max_redemptions: params[:max_redemptions],
      times_redeemed: params[:times_redeemed],
      duration_in_months: params[:duration_in_months],
      valid: true,
      metadata: {}
    }
  end

  def customer(id = CUSTOMER_ID)
    {
      object: "customer",
      created: 1359583041,
      id: id,
      livemode: false,
      description: CUSTOMER_EMAIL,
      email: CUSTOMER_EMAIL,
      delinquent: false,
      metadata: {},
      subscriptions: {
        object: "list",
        total_count: 1,
        has_more: false,
        url: "/v1/customers/#{id}/subscriptions",
        data: [customer_subscription]
      },
      discount: nil,
      account_balance: 0,
      currency: "usd",
      cards: {
        object: "list",
        total_count: 1,
        has_more: false,
        url: "/v1/customers/#{id}/cards",
        data: [card]
      },
      default_card: "card_2NCtCAVwvnMUUs"
    }
  end

  def customer_invoice
    {
      date: 1369159688,
      id: "in_1s4JSgbcUaElzU",
      period_start: 1366567645,
      period_end: 1369159645,
      lines: {
        object: "list",
        total_count: 1,
        has_more: false,
        url: "/v1/invoices/in_1s4JSgbcUaElzU/lines",
        data: [
          {
            id: "sub_1ri03Utwow0Sue",
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
              name: I18n.t("shared.subscription.name"),
              created: 1367971199,
              amount: 9900,
              currency: "usd",
              id: "upcase",
              object: "plan",
              livemode: false,
              interval_count: 1,
              trial_period_days: nil,
              metadata: {},
              statement_description: nil
            },
            description: nil,
            metadata: nil
          }
        ],
      },
      subtotal: 9900,
      total: 7900,
      customer: CUSTOMER_ID,
      object: "invoice",
      attempted: true,
      closed: true,
      forgiven: false,
      paid: true,
      livemode: false,
      attempt_count: 1,
      amount_due: 7900,
      currency: "usd",
      starting_balance: 0,
      ending_balance: 0,
      next_payment_attempt: nil,
      webhooks_delivered_at: 1403972754,
      charge: "ch_JQhSfU9Rz21owt",
      discount: {
        coupon: {
          id: "railsconf",
          created: 1410384799,
          percent_off: nil,
          amount_off: 2000,
          currency: "usd",
          object: "coupon",
          livemode: false,
          duration: "once",
          redeem_by: 1367971199,
          max_redemptions: nil,
          times_redeemed: 1,
          duration_in_months: nil,
          valid: true,
          metadata: {}
        },
        start: 1336671710,
        object: "discount",
        customer: CUSTOMER_ID,
        subscription: nil,
        end: 1339350110
      },
      application_fee: nil,
      subscription: "sub_3Xehu54zpkQS1b",
      description: nil,
      receipt_number: nil
    }
  end

  def customer_invoice_with_discount_in_percent
    customer_invoice.merge(
      id: "in_3Eh5UIbuDVdhat",
      discount: {
        coupon: {
          id: "RESOLVE2014",
          percent_off: 100,
          amount_off: nil,
          currency: nil,
          object: "coupon",
          livemode: false,
          duration: "once",
          redeem_by: 1389225599,
          max_redemptions: nil,
          times_redeemed: 77,
          duration_in_months: nil,
          valid: true,
          metadata: {}
        },
        start: 1388677692,
        object: "discount",
        customer: CUSTOMER_ID,
        subscription: nil,
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
      id: "in_3lNBWqTVMT9sFb",
      period_start: 1366567645,
      period_end: 1369159645,
      lines: {
        object: "list",
        total_count: 2,
        has_more: false,
        url: "/v1/invoices/in_3lNBWqTVMT9sFb/lines",
        data: [
          {
            id: "ii_3XgI5MRjNLJsqj",
            object: "line_item",
            type: "invoiceitem",
            livemode: false,
            amount: 9876,
            currency: "usd",
            proration: true,
            period: {
              start: 1393056868,
              end: 1393056868
            },
            quantity: 1,
            plan: {
              interval: "month",
              name: "Prime Workshops",
              created: 1360789384,
              amount: 9900,
              currency: "usd",
              id: "prime",
              object: "plan",
              livemode: false,
              interval_count: 1,
              trial_period_days: nil,
              metadata: {},
              statement_description: nil
            },
            description: "Remaining time on Upcase VideoTutorials after 22 Feb 2014",
            metadata: {}
          },
          {
            id: "ii_3XgIlCOcNHW6pT",
            object: "line_item",
            type: "invoiceitem",
            livemode: false,
            amount: -2893,
            currency: "usd",
            proration: true,
            period: {
              start: 1393056868,
              end: 1393056868
            },
            quantity: 1,
            plan: {
              interval: "month",
              name: "Prime Basic",
              created: 1376357374,
              amount: 2900,
              currency: "usd",
              id: "prime-basic",
              object: "plan",
              livemode: false,
              interval_count: 1,
              trial_period_days: nil,
              metadata: {},
              statement_description: nil
            },
            description: "Unused time on Upcase Basic after 22 Feb 2014",
            metadata: {}
          }
        ]
      },
      subtotal: 6983,
      total: 6983,
      customer: CUSTOMER_ID,
      object: "invoice",
      attempted: true,
      closed: true,
      forgiven: false,
      paid: true,
      livemode: false,
      attempt_count: 1,
      amount_due: 6983,
      currency: "usd",
      starting_balance: 0,
      ending_balance: 0,
      next_payment_attempt: nil,
      webhooks_delivered_at: 1395470224,
      charge: "ch_3iA6QoQ8ji0rpA",
      discount: nil,
      application_fee: nil,
      subscription: "sub_3Xehu54zpkQS1b",
      metadata: {},
      statement_description: nil,
      description: nil,
      receipt_number: "2507-2258"
    }
  end

  def customer_subscription
    {
      id: SUBSCRIPTION_ID,
      plan: {
        interval: "month",
        name: "Java Bindings Plan",
        created: 1403972754,
        amount: 100,
        currency: "usd",
        id: PLAN_ID,
        object: "plan",
        livemode: false,
        interval_count: 1,
        trial_period_days: nil,
        metadata: {},
        statement_description: nil
      },
      object: "subscription",
      start: 1358555835,
      status: "active",
      customer: CUSTOMER_ID,
      cancel_at_period_end: false,
      current_period_start: 1358555835,
      current_period_end: 1361234235,
      ended_at: nil,
      trial_start: nil,
      trial_end: nil,
      canceled_at: nil,
      quantity: 1,
      application_fee_percent: nil,
      discount: nil,
      metadata: {}
    }
  end

  def charge(charge_id = "ch_JQhSfU9Rz21owt")
    {
      id: charge_id,
      object: "charge",
      created: 1336671705,
      livemode: false,
      paid: true,
      amount: 1500,
      currency: "usd",
      refunded: false,
      card: card,
      captured: true,
      refunds: {
        object: "list",
        total_count: 0,
        has_more: false,
        url: "/v1/charges/#{charge_id}/refunds",
        data: []
      },
      balance_transaction: "txn_2OMDmEVTgCgMmp",
      failure_message: nil,
      failure_code: nil,
      amount_refunded: 0,
      customer: CUSTOMER_ID,
      invoice: "in_1s4JSgbcUaElzU",
      description: nil,
      dispute: nil,
      metadata: {},
      statement_description: nil,
      receipt_email: nil,
      receipt_number: nil
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
      card: card.except(:cvc_check, :address_line1_check, :address_zip_check)
    }
  end

  def card
    {
      id: "card_2NCtCAVwvnMUUs",
      object: "card",
      last4: "1234",
      brand: "Visa",
      funding: "credit",
      exp_month: 2,
      exp_year: 2016,
      fingerprint: "61N1s4XuvJOoLAnb",
      country: "US",
      name: nil,
      address_line1: nil,
      address_line2: nil,
      address_city: nil,
      address_state: nil,
      address_zip: nil,
      address_country: nil,
      cvc_check: "pass",
      address_line1_check: nil,
      address_zip_check: nil,
      customer: CUSTOMER_ID
    }
  end

  def paginate(collection:, starting_after:, limit:)
    collection.
      split { |item| item[:id] == starting_after }.
      last.
      take(limit)
  end
end

FakeStripeRunner = Capybara::Discoball::Runner.new(FakeStripe) do |server|
  url = "http://#{server.host}:#{server.port}"
  Stripe.api_base = url
end

RSpec.configure do |config|
  config.before { FakeStripe.reset }
end

Stripe.verify_ssl_certs = false

module Stripe
  # Overriding this so it does not warn us about turning off SSL
  def self.ssl_preflight_passed?
    true
  end
end
