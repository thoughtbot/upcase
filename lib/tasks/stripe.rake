namespace :stripe do
  task sync: :environment do
    StripeSubscriptionsChecker.new(output: STDOUT).check_all
  end
end
