class StripeCustomer
  def initialize(user)
    @user = user
  end

  def url
    if id.present?
      "https://manage.stripe.com/customers/#{id}"
    else
      nil
    end
  end

  private

  attr_reader :user

  def id
    user.stripe_customer_id
  end
end
