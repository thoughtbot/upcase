namespace :subscriptions do
  desc 'Updates the next payment amount for each active subscription'
  task :update_next_payment_amount => :environment do
    SubscriptionUpcomingInvoiceUpdater.new(Subscription.paid).process
  end

  desc 'Send emails to subscribers that will be billed 2 days from today'
  task :upcoming_payment_notification => :environment do
    SubscriptionPaymentComingUpNotifier.new(Subscription.active.next_payment_in_2_days).process
  end
end
