class PurchaseMailer < BaseMailer
  def fulfillment_error(purchase, username)
    @username = username
    @purchase = purchase

    mail(
      to: purchase.email,
      cc: ENV["SUPPORT_EMAIL"],
      subject: "Fulfillment issues with #{purchase.purchaseable_name}"
    )
  end

  def purchase_receipt(purchase)
    @purchase = purchase

    mail(
      to: @purchase.email,
      subject: "Your receipt for #{@purchase.purchaseable_name}"
    )
  end
end
