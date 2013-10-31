class PurchaseInfoCopier
  def initialize(purchase, user)
    @purchase = purchase
    @user = user
  end

  def copy_info_to_user
    save_github_username_to_user
    save_organization_to_user
    save_address_to_user
  end

  private
  attr_reader :purchase, :user

  def save_github_username_to_user
    if purchase.github_usernames.present? && user.github_username.blank?
      user.update_column(:github_username, purchase.github_usernames.first)
    end
  end

  def save_organization_to_user
    if purchase.organization.present?
      write_user_columns %w(organization)
    end
  end

  def save_address_to_user
    if purchase.address1.present?
      write_user_columns(%w(address1 address2 city state zip_code country))
    end
  end

  def write_user_columns(names)
    if user
      names.each { |name| user.update_column(name, purchase.send(name)) }
    end
  end
end
