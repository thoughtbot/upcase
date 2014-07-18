class PurchaseMailer < BaseMailer
  def purchase_receipt(purchase)
    @purchase = purchase

    mail(
      to: @purchase.email,
      subject: "Your receipt for #{@purchase.purchaseable_name}"
    )
  end
end
