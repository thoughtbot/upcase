class PurchaseMailer < BaseMailer
  def follow_up(follow_up, section)
    @section = section

    mail(
      to: follow_up.email,
      subject: "The #{@section.workshop.name} workshop has been scheduled"
    )
  end

  def fulfillment_error(purchase, username)
    @username = username
    @purchase = purchase

    mail(
      to: purchase.email,
      cc: 'learn@thoughtbot.com',
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "Fulfillment issues with #{purchase.purchaseable_name}"
    )
  end
end
