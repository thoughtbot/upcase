require 'spec_helper'

describe IndividualPlan do
  it { should have_many(:announcements) }
  it { should have_many(:purchases) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:sku) }

  it { should_not be_fulfilled_with_github }
  it { should be_subscription }

  describe '.active' do
    it 'only includes active plans' do
      active = create(:plan, active: true)
      inactive = create(:plan, active: false)
      expect(IndividualPlan.active).to eq [active]
    end
  end

  describe '.featured' do
    it 'only featured plans' do
      featured = create(:plan, featured: true)
      notfeatured = create(:plan, featured: false)
      expect(IndividualPlan.featured).to eq [featured]
    end
  end

  describe '.ordered' do
    it 'sorts by individual price' do
      second = create(:plan, individual_price: 29)
      first = create(:plan, individual_price: 99)
      expect(IndividualPlan.ordered).to eq [first, second]
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

  describe '.prime_basic' do
    it 'returns the instance of IndividualPlan corresponding to Prime Basic' do
      create_prime_basic_plan

      expect(IndividualPlan.prime_basic).to eq IndividualPlan.find_by_sku(IndividualPlan::PRIME_BASIC_SKU)
    end
  end

  describe '.prime_workshops' do
    it 'returns the IndividualPlan instance corresponding to Prime Workshops' do
      create_prime_workshops_plan

      expect(IndividualPlan.prime_workshops).to eq IndividualPlan.find_by_sku(IndividualPlan::PRIME_WORKSHOPS_SKU)
    end
  end

  describe '.prime_with_mentoring' do
    it 'returns the IndividualPlan instance corresponding to Prime with Mentoring' do
      create_prime_with_mentoring_plan

      expect(IndividualPlan.prime_with_mentoring).to eq IndividualPlan.find_by_sku(IndividualPlan::PRIME_WITH_MENTORING_SKU)
    end
  end

  describe '.downgraded' do
    it 'returns the downgraded plan' do
      downgraded_plan = create(:downgraded_plan)
      create(:plan)

      expect(IndividualPlan.downgraded).to eq downgraded_plan
    end
  end

  describe '#subscription_count' do
    it 'returns 0 when the plan has no subscriptions' do
      plan = create(:plan)
      expect(plan.subscription_count).to eq 0
    end

    it 'returns 1 when the plan has a single active subscription that is paid' do
      plan = create(:plan)
      create(:active_subscription, plan: plan, paid: true)
      expect(plan.subscription_count).to eq 1
    end

    it 'returns 0 when the plan has an active subscription that is unpaid' do
      plan = create(:plan)
      create(:active_subscription, plan: plan, paid: false)
      expect(plan.subscription_count).to eq 0
    end

    it 'returns 0 when the plan has only an inactive subscription' do
      plan = create(:plan)
      create_inactive_subscription_for(plan)
      expect(plan.subscription_count).to eq 0
    end
  end

  describe '#to_param' do
    it 'returns the sku' do
      plan = create(:plan)
      plan.to_param.should == "#{plan.sku}"
    end
  end

  describe 'purchase_for' do
    it 'returns the purchase when a user has purchased the plan' do
      create_mentors
      user = create(:user)
      purchase = create(:plan_purchase, user: user)
      plan = purchase.purchaseable

      expect(plan.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased the plan' do
      create_mentors
      user = create(:user)
      purchase = create(:plan_purchase)
      plan = purchase.purchaseable

      expect(plan.purchase_for(user)).to be_nil
    end
  end

  describe 'starts_on' do
    it 'returns the given date' do
      plan = create(:plan)
      expect(plan.starts_on(Time.zone.today)).to eq Time.zone.today
    end
  end

  describe 'ends_on' do
    it 'returns the given date' do
      plan = create(:plan)
      expect(plan.ends_on(Time.zone.today)).to eq Time.zone.today
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

  describe 'offering_type' do
    it 'returns subscription' do
      plan = build_stubbed(:plan)

      result = plan.offering_type

      expect(result).to eq 'subscription'
    end
  end

  describe 'fulfillment_method' do
    it 'returns subscription' do
      plan = build_stubbed(:plan)

      result = plan.fulfillment_method

      expect(result).to eq 'subscription'
    end
  end

  describe '#alternates' do
    it 'is empty' do
      plan = IndividualPlan.new

      result = plan.alternates

      expect(result).to eq []
    end
  end

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      plan = create(:plan)
      plan.announcement
      expect(Announcement).to have_received(:current)
    end
  end

  def create_prime_basic_plan
    create(:plan, sku: IndividualPlan::PRIME_BASIC_SKU)
  end

  def create_prime_workshops_plan
    create(:plan, sku: IndividualPlan::PRIME_WORKSHOPS_SKU)
  end

  def create_prime_with_mentoring_plan
    create(:plan, sku: IndividualPlan::PRIME_WITH_MENTORING_SKU)
  end

  def create_inactive_subscription_for(plan)
    create(:inactive_subscription, plan: plan)
  end

  def create_active_subscription_for(plan)
    create(:subscription, plan: plan)
  end

end
