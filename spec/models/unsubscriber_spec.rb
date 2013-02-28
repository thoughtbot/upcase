require 'spec_helper'

describe Unsubscriber do
  it 'destroys the subscription' do
    subscription = create(:subscription)
    unsubscriber = Unsubscriber.new(subscription)

    subscription.stubs(:stripe_customer).returns('cus_1CXxPJDpw1VLvJ')
    unsubscriber.process

    subscription.should_not be_persisted
  end

  it 'unsubscribes from Stripe' do
    subscription = create(:subscription)
    unsubscriber = Unsubscriber.new(subscription)

    stripe_customer = stub('Stripe::Customer', cancel_subscription: nil)
    Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
    unsubscriber.process

    stripe_customer.should have_received(:cancel_subscription)
  end

  it 'retrieves the customer correctly' do
    subscription = create(:subscription)
    unsubscriber = Unsubscriber.new(subscription)

    subscription.stubs(:stripe_customer).returns('cus_1CXxPJDpw1VLvJ')
    stripe_customer = stub('Stripe::Customer', cancel_subscription: nil)
    Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
    unsubscriber.process

    Stripe::Customer.should have_received(:retrieve).with('cus_1CXxPJDpw1VLvJ')
  end

  it 'does not destroy subscription if stripe unsubscribe fails' do
    subscription = create(:subscription)
    unsubscriber = Unsubscriber.new(subscription)

    stripe_customer = stub('Stripe::Customer')
    stripe_customer.stubs(:cancel_subscription).raises(Stripe::APIError)
    Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

    expect { unsubscriber.process }.to raise_error
    Subscription.find(subscription.id).should be_present
  end

  it 'does not unsubscribe from stripe if destroying the subscription failed' do
    subscription = create(:subscription)
    unsubscriber = Unsubscriber.new(subscription)

    stripe_customer = stub('Stripe::Customer')
    subscription.stubs(:destroy).raises(ActiveRecord::RecordNotSaved)
    Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

    expect { unsubscriber.process }.to raise_error
    subscription.should have_received(:cancel_subscription).never
  end
end
