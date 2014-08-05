require 'spec_helper'

describe IndividualPlan do
  it { should have_many(:announcements) }
  it { should have_many(:checkouts) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:sku) }

  it_behaves_like 'a Plan for public listing'

  describe '.active' do
    it 'only includes active plans' do
      active = create(:plan, active: true)
      inactive = create(:plan, active: false)
      expect(IndividualPlan.active).to eq [active]
    end
  end

  describe '.default' do
    it 'returns the first, active, featured, ordered plan' do
      ordered = stub(first: stub())
      featured = stub(ordered: ordered)
      active = stub(featured: featured)
      IndividualPlan.stubs(active: active)

      IndividualPlan.default

      expect(ordered).to have_received(:first)
      expect(featured).to have_received(:ordered)
      expect(active).to have_received(:featured)
      expect(IndividualPlan).to have_received(:active)
    end
  end

  describe '.basic' do
    it 'returns the basic plan' do
      basic_plan = create(:basic_plan)
      create(:plan)

      expect(IndividualPlan.basic).to eq basic_plan
    end
  end

  describe 'subscription_interval' do
    it 'returns the interval from the stripe plan' do
      plan = build_stubbed(:plan)
      stripe_plan = stub(interval: 'year')
      Stripe::Plan.stubs(:retrieve).returns(stripe_plan)

      expect(plan.subscription_interval).to eq 'year'
      expect(Stripe::Plan).to have_received(:retrieve).with(plan.sku)
    end
  end

  describe '#fulfill' do
    it 'starts a subscription' do
      user = build_stubbed(:user)
      user.stubs(:create_purchased_subscription)
      plan = build_stubbed(:individual_plan)
      checkout = build_stubbed(:checkout, user: user, subscribeable: plan)
      fulfillment = stub_subscription_fulfillment(checkout)

      plan.fulfill(checkout, user)

      expect(fulfillment).to have_received(:fulfill)
      expect(user).
        to have_received(:create_purchased_subscription).with(plan: plan)
    end
  end

  describe '#after_checkout_url' do
    it 'returns the dashboard path' do
      dashboard_path = 'http://example.com/dashboard'
      plan = build_stubbed(:individual_plan)
      checkout = build_stubbed(:checkout, subscribeable: plan)
      controller = stub('controller')
      controller.stubs(:dashboard_path).returns(dashboard_path)

      after_checkout_url = plan.after_checkout_url(controller, checkout)

      expect(after_checkout_url).to eq(dashboard_path)
    end
  end

  describe "#has_feature?" do
    it "returns true if the plan has the feature" do
      plan = build_stubbed(:individual_plan, :includes_mentor)
      expect(plan.has_feature?(:mentor)).to be true
    end

    it "returns false if the plan does not have the feature" do
      plan = build_stubbed(:individual_plan, :no_mentor)
      expect(plan.has_feature?(:mentor)).to be false
    end

    it "raises an exception with an invalid feature name" do
      plan = build_stubbed(:individual_plan)
      expect{ plan.has_feature?(:foo) }.to raise_error
    end
  end

  def create_inactive_subscription_for(plan)
    create(:inactive_subscription, plan: plan)
  end

  def create_active_subscription_for(plan)
    create(:subscription, plan: plan)
  end
end
