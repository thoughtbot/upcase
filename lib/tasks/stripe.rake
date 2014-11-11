namespace :stripe do
  task sync: :environment do
    StripeSubscriptionSynchronizer.new.check_all
  end
end
