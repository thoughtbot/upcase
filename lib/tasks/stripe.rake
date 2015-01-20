namespace :stripe do
  task sync: :environment do
    StripeSubscriptionSynchronizer.new($stdout).check_all
  end
end
