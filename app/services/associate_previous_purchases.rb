class AssociatePreviousPurchases
  def self.create_associations_for(user)
    associator = new(user)
    associator.associate_purchases
    associator.associate_stripe_customer_id
  end

  def initialize(user)
    @user = user
  end

  def associate_purchases
    user.purchases << previous_purchases
  end

  def associate_stripe_customer_id
    if existing_stripe_customer_id.present?
      user.update_column(:stripe_customer_id, existing_stripe_customer_id)
    end
  end

  private

  attr_accessor :user

  def previous_purchases
    Purchase.by_email(user.email)
  end

  def existing_stripe_customer_id
    if previous_purchases.with_stripe_customer_id.any?
      previous_purchases.with_stripe_customer_id.last.stripe_customer_id
    end
  end
end
