require "rails_helper"

RSpec.describe PausedSubscription do
  describe "#schedule" do
    it "sets the reactivation date to 90 days after end of billing period" do
      subscription = create(:subscription)
      pause = PausedSubscription.new(subscription)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)

      pause.schedule

      expect(subscription.scheduled_for_reactivation_on).
        to eq Time.zone.at(billing_period_end + 90.days).to_date
    end

    it "cancels the subscription" do
      subscription = create(:subscription)
      pause = PausedSubscription.new(subscription)
      cancellation = double(schedule: true)

      allow(Cancellation).to receive(:new).
        with(subscription: subscription).
        and_return(cancellation)

      pause.schedule

      expect(cancellation).to have_received(:schedule)
    end

    def stripe_customer
      @stripe_customer ||= double(
        "Stripe::Customer",
        subscriptions: [
          double(
            "Subscription",
            current_period_end: billing_period_end,
            delete: true,
          ),
        ]
      )
    end

    def billing_period_end
      _tuesday_feb_19_2013 = 1361234235
    end
  end
end
