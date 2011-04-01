class Registration < ActiveRecord::Base
  include ActionController::UrlWriter
  belongs_to :section
  belongs_to :user
  belongs_to :coupon

  after_create :store_freshbooks_invoice
  after_create :send_notification_email

  validates_associated :user

  def store_freshbooks_invoice
    response = create_freshbooks_invoice
    if response.success?
      self.freshbooks_invoice_id = response['invoice_id']
      self.save
    end
  end

  def freshbooks_invoice_url
    self.attributes['freshbooks_invoice_url'] || fetch_invoice_url
  end

  private

  def send_notification_email
    Mailer.deliver_registration_notification(self)
  end

  def freshbooks_client
    @freshbooks_client ||= FreshBooks::Client.new(FRESHBOOKS_PATH, FRESHBOOKS_TOKEN)
  end

  def create_freshbooks_invoice
    freshbooks_client.invoice.create(:invoice => {
                                    :client_id     => self.user.freshbooks_client_id,
                                    :return_uri    => section_url(self.section, :host => ActionMailer::Base.default_url_options[:host]),
                                    :first_name    => self.user.first_name,
                                    :last_name     => self.user.last_name,
                                    :organization  => self.user.organization,
                                    :p_street1     => self.user.address1,
                                    :p_city        => self.user.city,
                                    :p_code        => self.user.zip_code,
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
