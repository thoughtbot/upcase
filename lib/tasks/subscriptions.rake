namespace :subscriptions do
  desc "Notify people 2 days away from paused subscriptions restarting"
  task upcoming_reactivation_notification: :environment do
    PendingReactivationNotifier.notify
  end

  desc "Resubscribes people who were paused and are due to restart today"
  task unpause_subscriptions: :environment do
    SubscriptionsRestarter.restart_todays_paused_subscriptions
  end

  desc "Updates the next payment amount for each active subscription"
  task update_next_payment_amount: :environment do
    SubscriptionUpcomingInvoiceUpdater.new(Subscription.all).process
  end

  desc "Send emails to subscribers that will be billed 2 days from today"
  task upcoming_payment_notification: :environment do
    about_to_be_billed = Subscription.active.next_payment_in_2_days
    SubscriptionPaymentComingUpNotifier.new(about_to_be_billed).process
  end
end
