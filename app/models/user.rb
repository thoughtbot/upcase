class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :email, :first_name, :github_username, :last_name, :password, :auth_provider, :auth_uid

  has_many :purchases
  has_many :registrations

  validates_presence_of :first_name, :last_name

  after_create :associate_previous_purchases
  after_create :associate_previous_registrations

  def self.find_or_create_from_auth_hash(auth_hash)
    find_by_auth_hash(auth_hash) || create_from_auth_hash(auth_hash)
  end

  def self.find_by_auth_hash(auth_hash)
    where(auth_provider: auth_hash['provider'], auth_uid: auth_hash['uid']).first
  end

  def self.create_from_auth_hash(auth_hash)
    p auth_hash
    name = auth_hash['info']['name'].split(' ')
    create(
      auth_provider: auth_hash['provider'],
      auth_uid: auth_hash['uid'],
      first_name: name.first, 
      last_name: name.last, 
      email: auth_hash['info']['email'], 
      github_username: auth_hash['info']['nickname']
    )
  end

  def name
    [first_name, last_name].join(' ')
  end

  def external_auth?
    auth_provider.present?
  end

  private

  def password_optional?
    external_auth?
  end

  def associate_previous_purchases
    previous_purchases = Purchase.by_email(email)
    self.purchases << previous_purchases
    self.update_column(:stripe_customer, previous_purchases.stripe.last.try(:stripe_customer))
  end

  def associate_previous_registrations
    previous_registrations = Registration.by_email(email)
    self.registrations << previous_registrations
  end
end
