require 'spec_helper'

describe Unsubscriber do
  it 'makes the subscription inactive and records the current date' do
    subscription = create(:subscription)
    unsubscriber = Unsubscriber.new(subscription)

    subscription.stubs(:stripe_customer_id).returns('cus_1CXxPJDpw1VLvJ')
    unsubscriber.process

    subscription.deactivated_on.should == Date.today
  end

  describe 'schedule' do
    it 'schedules a cancelation with Stripe' do
      subscription = create(:subscription)
      unsubscriber = Unsubscriber.new(subscription)

      stripe_customer = stub(
        'Stripe::Customer',
        cancel_subscription: nil,
        subscription: stub(current_period_end: 1361234235)
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      unsubscriber.schedule

      stripe_customer.should have_received(:cancel_subscription).
        with(at_period_end: true)

      subscription.scheduled_for_cancelation_on.should eq Time.at(1361234235)
    end

    it 'retrieves the customer correctly' do
      subscription = create(:subscription)
      unsubscriber = Unsubscriber.new(subscription)

      subscription.stubs(:stripe_customer_id).returns('cus_1CXxPJDpw1VLvJ')
      stripe_customer = stub(
        'Stripe::Customer',
        cancel_subscription: nil,
        subscription: stub(current_period_end: 1361234235)
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      unsubscriber.schedule

      Stripe::Customer.should have_received(:retrieve).with('cus_1CXxPJDpw1VLvJ')
    end

    it 'does not make the subscription inactive if stripe unsubscribe fails' do
      subscription = create(:subscription)
      unsubscriber = Unsubscriber.new(subscription)

      stripe_customer = stub('Stripe::Customer')
      stripe_customer.stubs(:cancel_subscription).raises(Stripe::APIError)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { unsubscriber.schedule }.to raise_error
      Subscription.find(subscription.id).should be_active
    end

    it 'does not unsubscribe from stripe if deactivating the subscription failed' do
      subscription = create(:subscription)
      unsubscriber = Unsubscriber.new(subscription)

      stripe_customer = stub('Stripe::Customer')
      subscription.stubs(:destroy).raises(ActiveRecord::RecordNotSaved)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { unsubscriber.schedule }.to raise_error
      subscription.should have_received(:cancel_subscription).never
    end
  end
end
