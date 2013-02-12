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
end
