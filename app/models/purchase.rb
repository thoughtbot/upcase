require 'digest/md5'

class Purchase < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  PAYMENT_METHODS = %w(stripe paypal free)

  belongs_to :product
  belongs_to :coupon
  serialize :readers

  attr_accessor :stripe_token, :paypal_url

  validates_presence_of :variant, :product_id, :name, :email, :lookup, :payment_method
  validate :payment_method_must_match_price

  before_validation :generate_lookup, on: :create
  before_create :create_and_charge_customer, if: :stripe?
  before_create :setup_paypal_payment, if: :paypal?
  before_create :set_as_paid, if: :free?
  after_save :fulfill, if: :being_paid?
  after_save :send_receipt, if: :being_paid?

  delegate :name, to: :product, prefix: true

  def self.from_month(date)
    where(["created_at >= ? AND created_at <= ?", date.beginning_of_month, date.end_of_month])
  end

  def self.last_30_days
    (0..30).to_a.collect { |day| Purchase.where("created_at >= ? and created_at <= ?", day.days.ago.beginning_of_day, day.days.ago.end_of_day).all.sum(&:price) }.reverse
  end

  def self.from_period(start_time, end_time)
    Purchase.where("created_at >= ? and created_at <= ?", start_time, end_time).all.sum(&:price)
  end

  def self.host
    if defined?(@@host)
      @@host
    else
      ActionMailer::Base.default_url_options[:host]
    end
  end

  def self.host=(host)
    @@host = host
  end

  def price
    full_price = product.send(:"#{variant}_price")
    if coupon
      coupon.apply(full_price)
    else
      full_price
    end
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ").last
  end

  def fetch_order
    if product.fulfillment_method == "fetch"
      FetchAPI::Base.basic_auth(FETCH_DOMAIN, FETCH_USERNAME, FETCH_PASSWORD)
      FetchAPI::Order.find(id)
    end
  end

  def to_param
    lookup
  end

  def stripe?
    payment_method == "stripe"
  end

  def paypal?
    payment_method == "paypal"
  end

  def free?
    payment_method == "free"
  end

  def payment_method
    if price.zero?
      "free"
    else
      read_attribute :payment_method
    end
  end

  def complete_paypal_payment!(token, payer_id)
    response = paypal_request.checkout!(
      token,
      payer_id,
      paypal_payment_request
    )

    self.payment_transaction_id = response.payment_info.first.transaction_id
    self.paid = true
    save!
  end

  def success_url
    if paypal?
      paypal_url
    else
      product_purchase_path(product, self, host: self.class.host)
    end
  end

  private

  def being_paid?
    paid? && paid_was == false
  end

  def generate_lookup
    self.lookup = Digest::MD5.hexdigest("#{email}#{product.id}#{Time.now}\n").downcase
  end

  def create_and_charge_customer
    customer = Stripe::Customer.create(
      card: stripe_token,
      description: email,
      email: email
    )

    charge = Stripe::Charge.create(
      amount: price * 100, # in cents
      currency: "usd",
      customer: customer.id,
      description: product_name
    )

    self.payment_transaction_id = charge.id
    self.stripe_customer = customer.id
    self.paid = true
  end

  def setup_paypal_payment
    response = paypal_request.setup(
      paypal_payment_request,
      paypal_product_purchase_url(self.product, self, host: self.class.host),
      courses_url(host: self.class.host)
    )
    self.paid = false
    self.paypal_url = response.redirect_uri
  end

  def set_as_paid
    self.paid = true
  end

  def paypal_request
    Paypal::Express::Request.new(
      username: PAYPAL_USERNAME,
      password: PAYPAL_PASSWORD,
      signature: PAYPAL_SIGNATURE
    )
  end

  def paypal_payment_request
    Paypal::Payment::Request.new(
      currency_code: :USD,
      amount: price,
      description: product_name,
      items: [{ amount: price,
                   description: product_name }]
    )
  end

  def fulfill
    if product.fulfillment_method == "fetch"
      fulfill_with_fetch
    elsif product.fulfillment_method == "github"
      fulfill_with_github
    end
  end

  def fulfill_with_fetch
    FetchAPI::Base.basic_auth(FETCH_DOMAIN, FETCH_USERNAME, FETCH_PASSWORD)
    FetchAPI:Order.create(:id: id, title: product_name, first_name: first_name, last_name: last_name, email: email, order_items: [{sku: product.sku}])
  end

  def fulfill_with_github
    client = Octokit::Client.new(:login: "cpytel", password: "cambridge")
    readers.map(&:strip).reject(&:blank?).compact.each do |username|
      begin
        client.add_team_member(product.github_team, username)
      rescue Octokit::NotFound, Net::HTTPBadResponse => e
        Airbrake.notify(e)
      end
      sleep 0.2
    end
  end

  def send_receipt
    Mailer.purchase_receipt(self).deliver
  end

  def payment_method_must_match_price
    if free? && price > 0
      errors.add(:payment_method, 'cannot be free')
    end
  end
end
