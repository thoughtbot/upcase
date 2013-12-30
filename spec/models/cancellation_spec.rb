require 'spec_helper'

describe Cancellation do
  it 'makes the subscription inactive and records the current date' do
    subscription = create(:subscription)
    cancellation = Cancellation.new(subscription)

    subscription.stubs(:stripe_customer_id).returns('cus_1CXxPJDpw1VLvJ')
    cancellation.process

    subscription.deactivated_on.should == Time.zone.today
  end

  describe 'schedule' do
    it 'schedules a cancellation with Stripe' do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub(
        'Stripe::Customer',
        cancel_subscription: nil,
        subscription: stub(current_period_end: 1361234235)
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      cancellation.schedule

      stripe_customer.should have_received(:cancel_subscription).
        with(at_period_end: true)

      subscription.scheduled_for_cancellation_on.should eq Time.zone.at(1361234235).to_date
    end

    it 'retrieves the customer correctly' do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      subscription.stubs(:stripe_customer_id).returns('cus_1CXxPJDpw1VLvJ')
      stripe_customer = stub(
        'Stripe::Customer',
        cancel_subscription: nil,
        subscription: stub(current_period_end: 1361234235)
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      cancellation.schedule

      Stripe::Customer.should have_received(:retrieve).with('cus_1CXxPJDpw1VLvJ')
    end

    it 'does not make the subscription inactive if stripe unsubscribe fails' do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub('Stripe::Customer')
      stripe_customer.stubs(:cancel_subscription).raises(Stripe::APIError)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.schedule }.to raise_error
      Subscription.find(subscription.id).should be_active
    end

    it 'does not unsubscribe from stripe if deactivating the subscription failed' do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub('Stripe::Customer')
      subscription.stubs(:destroy).raises(ActiveRecord::RecordNotSaved)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.schedule }.to raise_error
      subscription.should have_received(:cancel_subscription).never
    end
  end

  describe '#can_downgrade_instead?' do
    it 'returns false if the subscribed plan is the downgrade plan' do
      stub_downgrade_plan
      subscribed_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription, plan: subscribed_plan)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.can_downgrade_instead?).to be_true
    end

    it 'returns true if the subscribed plan is not the downgrade plan' do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription, plan: downgrade_plan)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.can_downgrade_instead?).to be_false
    end
  end

  describe '#downgrade_plan' do
    it 'returns the basic plan' do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.downgrade_plan).to eq(downgrade_plan)
    end
  end

  describe '#subscribed_plan' do
    it 'returns the plan from the subscription' do
      subscription = build_stubbed(:subscription)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.subscribed_plan).to eq(subscription.plan)
    end
  end

  describe '#downgrade' do
    it 'switches to the downgrade plan' do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription)
      subscription.stubs(:change_plan)
      cancellation = Cancellation.new(subscription)

      cancellation.downgrade

      expect(subscription).to have_received(:change_plan).with(downgrade_plan)
    end
  end

  def stub_downgrade_plan
    build_stubbed(:plan).tap do |plan|
      IndividualPlan.stubs(:basic).returns(plan)
    end
  end
end
