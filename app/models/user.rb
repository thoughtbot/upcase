class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :email, :first_name, :github_username, :last_name, :password, :auth_provider, :auth_uid

  has_many :paid_purchases, class_name: 'Purchase',
    conditions: { paid: true }
  has_many :purchases

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :associate_previous_purchases

  def self.find_or_create_from_auth_hash(auth_hash)
    find_by_auth_hash(auth_hash) || create_from_auth_hash(auth_hash)
  end

  def self.find_by_auth_hash(auth_hash)
    where(auth_provider: auth_hash['provider'], auth_uid: auth_hash['uid']).first
  end

  def self.create_from_auth_hash(auth_hash)
    begin
      name = auth_hash['info']['name'] ? auth_hash['info']['name'].split(' ') : ['GitHub', 'User']
      create(
        auth_provider: auth_hash['provider'],
        auth_uid: auth_hash['uid'],
        first_name: name.first,
        last_name: name.last,
        email: auth_hash['info']['email'],
        github_username: auth_hash['info']['nickname']
      )
    rescue NoMethodError => e
      Airbrake.notify(
        :error_class   => "Auth hash error",
        :error_message => e.message,
        :parameters    => auth_hash
      )
    end
  end

  def name
    [first_name, last_name].join(' ')
  end

  def external_auth?
    auth_provider.present?
  end

  def has_purchased?
    paid_purchases.present?
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
end
