require "rails_helper"

RSpec.describe PendingReactivationNotifier do
  it "delivers emails to users about to restart a paused subscription" do
    fake_mailer = double("PauseMailer", deliver_later: true)
    subscription = create(
      :inactive_subscription,
      scheduled_for_reactivation_on: 2.days.from_now,
    )
    allow(PauseMailer).to receive(:pre_notification).
      with(subscription).
      and_return(fake_mailer)

    PendingReactivationNotifier.notify

    expect(PauseMailer).to have_received(:pre_notification).
      with(subscription).
      exactly(1).times

    expect(fake_mailer).to have_received(:deliver_later)
  end
end
