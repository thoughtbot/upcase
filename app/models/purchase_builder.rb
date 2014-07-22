class PurchaseBuilder
  def initialize(options)
    @params = options[:params]
    @user = options[:user]
    @purchases_collection = options[:purchases_collection]
  end

  def build
    attributes = permitted_params.merge(
      user: user,
      stripe_customer_id: existing_stripe_customer_id,
    )

    @purchases_collection.build(attributes)
  end

  private

  attr_reader :params, :user

  def permitted_params
    params.
      require(:purchase).
      permit(:stripe_coupon_id,
             :name,
             :email,
             :password,
             :github_username,
             :organization,
             :address1,
             :address2,
             :city,
             :state,
             :zip_code,
             :country,
             :payment_method,
             :stripe_token,
             :quantity)
  end

  def existing_stripe_customer_id
    if user.present? && using_existing_card?
      user.stripe_customer_id
    end
  end

  def using_existing_card?
    params[:use_existing_card] == 'on'
  end
end
