class CheckoutInfoCopier
  def initialize(checkout, user)
    @checkout = checkout
    @user = user
  end

  def copy_info_to_user
    save_github_username_to_user
    save_organization_to_user
    save_address_to_user
  end

  private
  attr_reader :checkout, :user

  def save_github_username_to_user
    if checkout.github_username.present? && user.github_username.blank?
      user.update_column(:github_username, checkout.github_username)
    end
  end

  def save_organization_to_user
    if checkout.organization.present?
      write_user_columns %w(organization)
    end
  end

  def save_address_to_user
    if checkout.address1.present?
      write_user_columns(%w(address1 address2 city state zip_code country))
    end
  end

  def write_user_columns(names)
    if user
      names.each { |name| user.update_column(name, checkout.send(name)) }
    end
  end
end
