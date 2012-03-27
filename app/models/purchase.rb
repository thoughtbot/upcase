require 'digest/md5'

class Purchase < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  PAYMENT_METHODS = %w(stripe paypal)

  belongs_to :product
  belongs_to :coupon
  serialize :readers

  attr_accessor :stripe_token, :paypal_url

  validates_presence_of :variant, :product_id, :name, :email, :lookup, :payment_method

  before_validation :generate_lookup, :on => :create
  before_create :create_and_charge_customer, :if => :stripe?
  before_create :setup_payal_payment, :if => :paypal?
  after_save :fulfill, :if => :being_paid?
  after_save :send_receipt, :if => :being_paid?

  delegate :name, :to => :product, :prefix => true

  def self.from_month(date)
    where(["created_at >= ? AND created_at <= ?", date.beginning_of_month, date.end_of_month])
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

  def complete_paypal_payment!(token, payer_id)
    paypal_request.checkout!(
      token,
      payer_id,
      paypal_payment_request
    )
    self.paid = true
    save!
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
      :card => stripe_token,
      :description => email,
      :email => email
    )

    Stripe::Charge.create(
      :amount => price * 100, # in cents
      :currency => "usd",
      :customer => customer.id,
      :description => product_name
    )

    self.stripe_customer = customer.id
    self.paid = true
  end

  def setup_payal_payment
    response = paypal_request.setup(
      paypal_payment_request,
      paypal_product_purchase_url(self.product, self, :host => ActionMailer::Base.default_url_options[:host]),
      courses_url(:host => ActionMailer::Base.default_url_options[:host])
    )
    self.paid = false
    self.paypal_url = response.redirect_uri
  end

  def paypal_request
    Paypal::Express::Request.new(
      :username   => PAYPAL_USERNAME,
      :password   => PAYPAL_PASSWORD,
      :signature  => PAYPAL_SIGNATURE
    )
  end

  def paypal_payment_request
    Paypal::Payment::Request.new(
      :currency_code => :USD,
      :amount        => price,
      :description   => product_name,
      :items => [{ :amount => price,
                   :description => product_name }]
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
    FetchAPI::Order.create(:id => id, :title => product_name, :first_name => first_name, :last_name => last_name, :email => email, :order_items => [{:sku => product.sku}])
  end

  def fulfill_with_github
    client = Octokit::Client.new(:login => "cpytel", :password => "cambridge")
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
end
