class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :last_name, :password, :email, :first_name

  has_many :purchases

  validates_presence_of :first_name, :last_name

  after_create :associate_previous_purchases

  def name
    [first_name, last_name].join(' ')
  end

  private

  def associate_previous_purchases
    previous_purchases = Purchase.by_email(email)
    self.purchases << previous_purchases
    self.update_column(:stripe_customer, previous_purchases.stripe.last.try(:stripe_customer))
  end
end
