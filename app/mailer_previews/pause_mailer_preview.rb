class PauseMailerPreview < ActionMailer::Preview
  def pause
    PauseMailer.pause(subscription)
  end

  def pre_notification
    PauseMailer.pre_notification(subscription)
  end

  def restarted
    PauseMailer.restarted(subscription)
  end

  private

  def subscription
    Subscription.first.tap do |subscription|
      subscription.user_clicked_cancel_button_on = 1.week.ago
    end
  end
end
