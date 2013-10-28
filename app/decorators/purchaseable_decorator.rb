class PurchaseableDecorator < SimpleDelegator
  def overlaps_with_other_purchases?(user)
    purchases = user.paid_purchases.where(purchaseable_type: 'Section')
    one_or_more_customer_purchases_overlap?(purchases)
  end

  private

  def one_or_more_customer_purchases_overlap?(paid_purchases)
    paid_purchases.any? { |purchase| overlaps_with?(purchase) }
  end

  def overlaps_with?(purchase)
    range = purchase.starts_on..purchase.ends_on
    range.cover?(start_date) || range.cover?(end_date)
  end

  def start_date
    starts_on(Time.zone.today)
  end

  def end_date
    ends_on(Time.zone.today)
  end
end
