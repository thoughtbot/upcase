class Checkout < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribeable, polymorphic: true

  validates :user_id, presence: true
  validates :quantity, presence: true
  validates :password, presence: true, if: :password_required?

  delegate :email, to: :user, prefix: true
  delegate :first_name, to: :user, prefix: true
  delegate :github_username, to: :user, prefix: true
  delegate :last_name, to: :user, prefix: true
  delegate :organization, to: :user, prefix: true
  delegate :sku, to: :subscribeable, prefix: true
  delegate :name, to: :subscribeable, prefix: true

  attr_accessor :email, :name, :github_username, :password, :stripe_customer_id, :stripe_token, :organization, :address1, :address2, :city, :state, :zip_code, :country

  before_validation :create_user, if: :password_required?
  before_create :place_payment
  after_save :save_info_to_user
  after_save :fulfill
  after_save :send_receipt
  after_save :update_user_payment_info

  private

  def create_user
    if name.present? && email.present? && password.present? && github_username.present?
      self.user = User.create(name: name, email: email, password: password, github_username: github_username)
      add_errors_from_user unless user.valid?
    end
  end

  def place_payment
    payment.place
  end

  def payment
    @payment ||= StripePayment.new(self)
  end

  def update_user_payment_info
    if user
      #payment.update_user(user)
    end
  end

  def fulfill
    subscribeable.fulfill(self, user)
  end

  def password_required?
    user.blank?
  end

  def send_receipt
    SendCheckoutReceiptEmailJob.enqueue(id)
  end

  def save_info_to_user
    CheckoutInfoCopier.new(self, user).copy_info_to_user
  end
end
