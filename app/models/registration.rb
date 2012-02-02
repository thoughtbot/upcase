class Registration < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :section
  belongs_to :coupon

  before_validation :populate_organization, :on => :create
  before_validation :populate_billing_email, :on => :create

  validates_presence_of :organization, :first_name, :last_name, :email, :billing_email

  after_create :store_freshbooks_client
  after_create :store_freshbooks_invoice

  def name
    [first_name, last_name].join(' ')
  end

  def freshbooks_invoice_url
    self.attributes['freshbooks_invoice_url'] || fetch_invoice_url
  end

  def receive_payment!
    self.paid = true
    save!
    Mailer.registration_notification(self).deliver
    Mailer.invoice(self).deliver
    Mailer.registration_confirmation(self).deliver
  end

  private

  def populate_organization
    if organization.blank?
      self.organization = "#{first_name} #{last_name}"
    end
  end

  def populate_billing_email
    if billing_email.blank?
      self.billing_email = email
    end
  end

  def store_freshbooks_client
    response = self.create_freshbooks_client
    if response.success?
      self.freshbooks_client_id = response['client_id']
      self.save
    else
      Rails.logger.error response.inspect
    end
  end

  def store_freshbooks_invoice
    response = create_freshbooks_invoice
    if response.success?
      self.freshbooks_invoice_id = response['invoice_id']
      self.save
    else
      Rails.logger.error response.inspect
    end
  end

  protected

  def create_freshbooks_client
    freshbooks_client.client.create(:client => {
      :first_name   => first_name,
      :last_name    => last_name,
      :organization => organization,
      :email        => billing_email,
      :work_phone   => phone,
      :p_street1    => address1,
      :p_street2    => address2,
      :p_city       => city,
      :p_state      => state,
      :p_country    => 'USA',
      :p_code       => zip_code
    })
  end

  def freshbooks_client
    @freshbooks_client ||= FreshBooks::Client.new(FRESHBOOKS_PATH, FRESHBOOKS_TOKEN)
  end

  def create_freshbooks_invoice
    freshbooks_client.invoice.create(:invoice => {
                                    :client_id     => self.freshbooks_client_id,
                                    :return_uri    => section_url(self.section, :host => ActionMailer::Base.default_url_options[:host]),
                                    :first_name    => self.first_name,
                                    :last_name     => self.last_name,
                                    :organization  => self.organization,
                                    :p_street1     => self.address1,
                                    :p_city        => self.city,
                                    :p_code        => self.zip_code,
                                    :status        => 'sent',
                                    :terms         => 'UPON RECEIPT',
                                    :discount      => (coupon.percentage if coupon),
                                    :lines => [{ :line => {
                                        :name         => 'Workshop',
                                        :description  => self.section.course_name,
                                        :unit_cost    => self.section.calculate_price,
                                        :quantity     => 1
                                      }}]
                                    })
  end

  def fetch_invoice_url
    response = freshbooks_client.invoice.get(:invoice_id => self.freshbooks_invoice_id)
    if response.success?
      self.freshbooks_invoice_url = response['invoice']['links']['client_view']
      self.save
      self.freshbooks_invoice_url
    end
  end
end
