class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :email, :first_name, :github_username, :last_name, :password

  has_many :purchases
  has_many :registrations

  validates_presence_of :first_name, :last_name

  after_create :associate_previous_purchases
  after_create :associate_previous_registrations

  def name
    [first_name, last_name].join(' ')
  end

  private

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
