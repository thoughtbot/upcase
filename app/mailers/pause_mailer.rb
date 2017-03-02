class PauseMailer < BaseMailer
  def pause(subscription)
    subscription_pauser = PausedSubscription.new(subscription)
    @restart_date = subscription_pauser.reactivation_date.strftime("%A, %B %e")
    @last_billing_date = subscription_pauser.last_billing_date.strftime("%B %e")
    @user = subscription.user

    mail(to: @user.email, subject: "Pausing your Upcase subscription")
  end

  def pre_notification(subscription)
    @pause_date = subscription.user_clicked_cancel_button_on.strftime("%B %-e")

    mail(
      to: subscription.user.email,
      subject: "Your Upcase subscription is about to restart",
    )
  end

  def restarted(previous_subscription)
    mail(
      to: previous_subscription.user.email,
      subject: "Your Upcase subscription is back!",
    )
  end
end
