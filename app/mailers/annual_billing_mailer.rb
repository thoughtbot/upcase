class AnnualBillingMailer < BaseMailer
  def notification(user)
    @user = user

    mail(to: ENV["SUPPORT_EMAIL"], subject: "Annual upgrade notification")
  end
end
