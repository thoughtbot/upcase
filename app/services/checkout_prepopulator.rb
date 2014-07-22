class CheckoutPrepopulator
  USER_ATTRIBUTES = %w(name email organization address1 address2 city state zip_code country)

  def initialize(checkout, user)
    @checkout = checkout
    @user = user
  end

  def prepopulate_with_user_info
    if user.present?
      copy_attributes_from_user_to_checkout
    end
    checkout
  end

  private
  attr_reader :checkout, :user

  def copy_attributes_from_user_to_checkout
    copy_attributes_from_user
    copy_github_username_from_user
  end

  def copy_attributes_from_user
    USER_ATTRIBUTES.each do |attr|
      checkout.send(:"#{attr}=", user.send(:"#{attr}"))
    end
  end

  def copy_github_username_from_user
    if user.github_username.present?
      checkout.github_username = user.github_username
    end
  end
end
