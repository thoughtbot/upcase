require "rails_helper"

RSpec.describe SubscriptionsRestarter do
  describe "#restart" do
    it "keeps old subscription and creates a new one" do
      subscription = create(:paused_subscription_restarting_today)
      user = subscription.user
      restarter = SubscriptionsRestarter.new(subscription)

      restarter.restart

      expect(user.subscriptions.count).to eq 2
    end

    it "marks previous subscription as having been reactivated" do
      subscription = create(
        :paused_subscription_restarting_today,
        reactivated_on: nil,
      )
      restarter = SubscriptionsRestarter.new(subscription)

      restarter.restart

      expect(subscription.reactivated_on).not_to be_nil
    end

    it "sends an email to the subscription owner" do
      subscription = create(:paused_subscription_restarting_today)
      restarter = SubscriptionsRestarter.new(subscription)
      PauseMailer.stub(restarted: double("mailer", deliver_later: true))

      restarter.restart

      expect(PauseMailer).to have_received(:restarted).with(subscription)
    end
  end

  describe ".restart_todays_paused_subscriptions" do
    it "restarts all paused subscriptions scheduled to re-up today" do
      todays_resubscription = create(:paused_subscription_restarting_today)
      future_subscription = create(:paused_subscription_restarting_tomorrow)

      todays_resubscription = stub_resubscriber_for(todays_resubscription)
      future_subscription = stub_resubscriber_for(future_subscription)

      SubscriptionsRestarter.restart_todays_paused_subscriptions

      expect(todays_resubscription).to have_received(:fulfill)
      expect(future_subscription).not_to have_received(:fulfill)
    end
  end

  def stub_resubscriber_for(subscription)
    double(:resubscriber, fulfill: true).tap do |resubscriber|
      allow(Resubscription).to receive(:new).
        with(user: subscription.user, plan: subscription.plan).
        and_return(resubscriber)
    end
  end
end
