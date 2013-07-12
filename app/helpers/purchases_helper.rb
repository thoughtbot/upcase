module PurchasesHelper
  def display_card_type(type)
    if type == "American Express"
      "AMEX"
    else
      type
    end
  end

  def include_receipt?(purchase)
    purchase.user.blank? ||
    !purchase.user.has_active_subscription? ||
    (purchase.user.has_active_subscription? && purchase.subscription?)
  end

  def coupon_redemption_url(purchaseable)
    polymorphic_path(
      [purchaseable, coupon_type(purchaseable)],
      action: :new,
      variant: params[:variant]
    )
  end

  def coupon_type(purchaseable)
    if purchaseable.subscription?
      :stripe_redemption
    else
      :redemption
    end
  end

  def submit_amount(purchase)
    if current_user_has_active_subscription?
      subscriber_amount
    else
      purchase_amount(purchase)
    end
  end

  def subscriber_amount
    number_to_currency(0, precision: 0)
  end

  def purchase_amount(purchase)
    if purchase.subscription?
      "#{purchase_price(purchase)} per #{subscription_interval(purchase)}"
    else
      number_to_currency(purchase.price, precision: 0)
    end
  end

  def purchase_price(purchase)
    number_to_currency(purchase.price, precision: 0)
  end

  def subscription_interval(purchase)
    purchase.purchaseable.subscription_interval
  end
end
