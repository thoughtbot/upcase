require 'spec_helper'

describe Cancellation do
  describe "#process" do
    before :each do
      subscription.stubs(:stripe_customer_id).returns("cus_1CXxPJDpw1VLvJ")

      mailer = stub(deliver: true)
      SubscriptionMailer.stubs(:cancellation_survey).
        with(subscription.user).returns(mailer)

      updater = stub(unsubscribe: true)
      AnalyticsUpdater.stubs(:new).with(subscription.user).returns(updater)
    end

    context "with an active subscription" do
      it "makes the subscription inactive and records the current date" do
        cancellation.process

        expect(subscription.deactivated_on).to eq Time.zone.today
      end

      it "sends a unsubscription survey email" do
        cancellation.process

        expect(SubscriptionMailer).
          to have_received(:cancellation_survey).with(subscription.user)
        expect(SubscriptionMailer.cancellation_survey(subscription.user)).
          to have_received(:deliver)
      end

      it "updates intercom status for user" do
        cancellation.process

        expect(AnalyticsUpdater).
          to have_received(:new).with(subscription.user)
        expect(AnalyticsUpdater.new(subscription.user)).
          to have_received(:unsubscribe)
      end
    end

    context "with an inactive subscription" do
      it "doesn't send any updates" do
        subscription.stubs(:active?).returns(false)

        cancellation.process

        expect(SubscriptionMailer.cancellation_survey(subscription.user)).
          to have_received(:deliver).never
        expect(AnalyticsUpdater.new(subscription.user)).
          to have_received(:unsubscribe).never
      end
    end
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

      expect(stripe_customer).to have_received(:cancel_subscription).
        with(at_period_end: true)

      expect(subscription.scheduled_for_cancellation_on).
        to eq Time.zone.at(1361234235).to_date
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

      expect(Stripe::Customer).to have_received(:retrieve)
        .with('cus_1CXxPJDpw1VLvJ')
    end

    it 'does not make the subscription inactive if stripe unsubscribe fails' do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub('Stripe::Customer')
      stripe_customer.stubs(:cancel_subscription).raises(Stripe::APIError)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.schedule }.to raise_error
      expect(Subscription.find(subscription.id)).to be_active
    end

    it 'does not unsubscribe from stripe if deactivating the subscription failed' do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub('Stripe::Customer')
      subscription.stubs(:destroy).raises(ActiveRecord::RecordNotSaved)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.schedule }.to raise_error
      expect(subscription).to have_received(:cancel_subscription).never
    end
  end

  describe 'cancel_and_refund' do
    it 'cancels immediately and refunds the last charge with Stripe' do
      subscription = create(:subscription)
      charge = stub('Stripe::Charge', id: 'charge_id', refund: nil)
      subscription.stubs(:last_charge).returns(charge)
      cancellation = Cancellation.new(subscription)
      stripe_customer = stub(
        'Stripe::Customer',
        cancel_subscription: nil,
        subscription: stub(current_period_end: 1361234235)
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      cancellation.cancel_and_refund

      expect(stripe_customer).to have_received(:cancel_subscription)
        .with(at_period_end: false)
      expect(charge).to have_received(:refund)
      expect(subscription.scheduled_for_cancellation_on).to be_nil
    end

    it 'does not error if the customer was not charged' do
      subscription = create(:subscription)
      subscription.stubs(:last_charge).returns(nil)
      cancellation = Cancellation.new(subscription)
      stripe_customer = stub(
        'Stripe::Customer',
        cancel_subscription: nil,
        subscription: stub(current_period_end: 1361234235)
      )
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.cancel_and_refund }.not_to raise_error
      expect(stripe_customer).to have_received(:cancel_subscription)
        .with(at_period_end: false)
    end
  end

  describe '#can_downgrade_instead?' do
    it 'returns false if the subscribed plan is the downgrade plan' do
      stub_downgrade_plan
      subscribed_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription, plan: subscribed_plan)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.can_downgrade_instead?).to be true
    end

    it 'returns true if the subscribed plan is not the downgrade plan' do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription, plan: downgrade_plan)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.can_downgrade_instead?).to be false
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

  def subscription
    @subscription ||= create(:subscription, :purchased)
  end

  def cancellation
    @cancellation ||= Cancellation.new(subscription)
  end
end
