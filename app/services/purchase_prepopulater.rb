class PurchasePrepopulater
  USER_ATTRIBUTES = %w(name email organization address1 address2 city state zip_code country)

  def initialize(purchase, user)
    @purchase = purchase
    @user = user
  end

  def prepopulate_with_user_info
    if user.present?
      copy_attributes_from_user_to_purchase
    end
    purchase
  end

  private
  attr_reader :purchase, :user

  def copy_attributes_from_user_to_purchase
    copy_attributes_from_user
    copy_github_usernames_from_user
  end

  def copy_attributes_from_user
    USER_ATTRIBUTES.each do |attr|
      purchase.send(:"#{attr}=", user.send(:"#{attr}"))
    end
  end

  def copy_github_usernames_from_user
    if github_username_needed? && user.github_username.present?
      purchase.github_usernames = [user.github_username]
    end
  end

  def github_username_needed?
    purchase.fulfilled_with_github? || purchase.subscription?
  end
end
