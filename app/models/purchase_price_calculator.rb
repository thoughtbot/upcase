class PurchasePriceCalculator
  def initialize(purchase, coupon)
    @purchase = purchase
    @coupon = coupon
  end

  def calculate
    if purchase.variant.blank?
      0
    else
      coupon.apply(full_price)
    end
  end

  private

  attr_reader :purchase, :coupon

  def full_price
    purchase.purchaseable.send(:"#{purchase.variant}_price") * purchase.quantity
  end
end
