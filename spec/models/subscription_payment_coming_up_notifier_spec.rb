require "rails_helper"

describe SubscriptionPaymentComingUpNotifier do
  it 'sends email to each subscribers' do
    mailer = spy("Mailer")
    allow(SubscriptionMailer).to receive(:upcoming_payment_notification).
      and_return(mailer)
    subscription_one = build_stubbed(:subscription)
    subscription_two = build_stubbed(:subscription)
    subscription_three = build_stubbed(:subscription)
    subscriptions = [subscription_one, subscription_two, subscription_three]

    SubscriptionPaymentComingUpNotifier.new(subscriptions).process

    expect(SubscriptionMailer).to have_received(:upcoming_payment_notification).
      with(subscription_one)
    expect(SubscriptionMailer).to have_received(:upcoming_payment_notification).
      with(subscription_two)
    expect(SubscriptionMailer).to have_received(:upcoming_payment_notification).
      with(subscription_three)
    expect(mailer).to have_received(:deliver_now).exactly(3).times
  end
end
