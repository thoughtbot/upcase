namespace :subscriptions do
  desc 'Updates the next payment amount for each active subscription'
  task :update_next_payment_amount => :environment do
    SubscriptionUpcomingInvoiceUpdater.new(Subscription.paid).process
  end
end
