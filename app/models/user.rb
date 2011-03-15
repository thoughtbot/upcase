class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :city, :address1, :address2, :zip_code, :password_confirmation,
        :phone, :last_name, :organization, :password, :state, :email, :first_name,
        :send_set_password

  attr_accessor :send_set_password
  validates_presence_of :first_name, :last_name

  has_many :registrations
  has_many :sections, :through => :registrations

  after_create :send_set_password_email, :if     => 'send_set_password'
  after_create :store_freshbooks_client, :unless => 'admin?'

  def registered_for?(section)
    admin? || sections.include?(section)
  end

  def name
    [first_name, last_name].join(' ')
  end

  private

  def send_set_password_email
    UserMailer.deliver_set_password(self)
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

  protected

  def create_freshbooks_client
    freshbooks_client.client.create(:client => {
      :first_name   => first_name,
      :last_name    => last_name,
      :organization => organization,
      :email        => email,
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
end
