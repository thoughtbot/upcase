class Registration < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # Associations
  belongs_to :coupon
  has_one :course, :through => :section
  belongs_to :section
  belongs_to :user

  # Validations
  validates :billing_email, presence: true
  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :organization, presence: true

  # Callbacks
  before_validation :populate_organization, on: :create
  before_validation :populate_billing_email, on: :create
  after_create :push_payment_for_zero_cost
  after_create :store_freshbooks_client
  after_create :store_freshbooks_invoice
  after_create :send_invoice

  def self.by_email(email)
    where email: email
  end

  def name
    [first_name, last_name].join(' ')
  end

  def freshbooks_invoice_url
    attributes['freshbooks_invoice_url'] || fetch_invoice_url
  end

  def receive_payment!
    set_as_paid
    save!
    send_payment_confirmations
  end

  def section_price
    section.course_price
  end

  def price
    if coupon
      coupon.apply(section_price)
    else
      section_price
    end
  end

  def defaults_from_user(purchaser)
    if purchaser
      self.first_name = purchaser.first_name
      self.last_name = purchaser.last_name
      self.email = purchaser.email
    end
  end

  private

  def create_freshbooks_client
    freshbooks_client.client.create(
      client: {
        email: billing_email,
        first_name: first_name,
        last_name: last_name,
        organization: organization,
        p_city: city,
        p_code: zip_code,
        p_country: 'USA',
        p_state: state,
        p_street1: address1,
        p_street2: address2,
        work_phone: phone
      }
    )
  end

  def create_freshbooks_invoice
    freshbooks_client.invoice.create(
      invoice: {
        client_id: freshbooks_client_id,
        first_name: first_name,
        last_name: last_name,
        lines: [{
          line: {
            name: 'Workshop',
            description: section.course_name,
            unit_cost: price,
            quantity: 1
          }
        }],
        organization: organization,
        p_city: city,
        p_code: zip_code,
        p_street1: address1,
        return_uri: section_url(
          section, host: ActionMailer::Base.default_url_options[:host]),
        status: 'sent',
        terms: 'UPON RECEIPT'
      }
    )
  end

  def freshbooks_client
    @freshbooks_client ||= FreshBooks::Client.new(
      FRESHBOOKS_PATH, FRESHBOOKS_TOKEN)
  end

  def fetch_invoice_url
    response = freshbooks_client.invoice.get(invoice_id: freshbooks_invoice_id)

    if response.success?
      self.freshbooks_invoice_url = response['invoice']['links']['client_view']
      save
      freshbooks_invoice_url
    end
  end

  def populate_billing_email
    if billing_email.blank?
      self.billing_email = email
    end
  end

  def populate_organization
    if organization.blank?
      self.organization = "#{first_name} #{last_name}"
    end
  end

  def push_payment_for_zero_cost
    if price == 0
      set_as_paid
      save!
      send_payment_confirmations
    end
  end

  def send_invoice
    Mailer.invoice(self).deliver
  end

  def send_payment_confirmations
    Mailer.registration_notification(self).deliver
    Mailer.registration_confirmation(self).deliver
  end

  def set_as_paid
    self.paid = true
    coupon.try :applied
  end

  def store_freshbooks_client
    response = create_freshbooks_client

    if response.success?
      self.freshbooks_client_id = response['client_id']
      save
    else
      Rails.logger.error response.inspect
    end
  end

  def store_freshbooks_invoice
    response = create_freshbooks_invoice

    if response.success?
      self.freshbooks_invoice_id = response['invoice_id']
      save
    else
      Rails.logger.error response.inspect
    end
  end
end
