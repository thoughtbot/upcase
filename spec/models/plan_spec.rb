require "rails_helper"

describe Plan do
  it { should have_many(:checkouts) }
  it { should have_many(:subscriptions) }
  it { should belong_to(:annual_plan).class_name("Plan") }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:sku) }

  it_behaves_like "a Plan for public listing"

  describe ".active" do
    it "only includes active plans" do
      active = create(:plan, active: true)
      _inactive = create(:plan, active: false)
      expect(Plan.active).to eq [active]
    end
  end

  describe ".default" do
    it "returns the first, active, featured, ordered plan" do
      ordered = stub(first: stub())
      featured = stub(ordered: ordered)
      active = stub(featured: featured)
      individual = stub(active: active)
      Plan.stubs(individual: individual)

      Plan.default

      expect(ordered).to have_received(:first)
      expect(featured).to have_received(:ordered)
      expect(active).to have_received(:featured)
      expect(individual).to have_received(:active)
      expect(Plan).to have_received(:individual)
    end
  end

  describe ".default_team" do
    it "returns the first, active, featured, ordered team plan" do
      ordered = stub(first: stub())
      featured = stub(ordered: ordered)
      active = stub(featured: featured)
      team = stub(active: active)
      Plan.stubs(team: team)

      Plan.default_team

      expect(ordered).to have_received(:first)
      expect(featured).to have_received(:ordered)
      expect(active).to have_received(:featured)
      expect(team).to have_received(:active)
      expect(Plan).to have_received(:team)
    end
  end

  describe ".basic" do
    it "returns the basic plan" do
      basic_plan = create(:basic_plan)
      create(:plan)

      expect(Plan.basic).to eq basic_plan
    end
  end

  describe "subscription_interval" do
    it "returns the interval from the stripe plan" do
      plan = build_stubbed(:plan)
      stripe_plan = stub(interval: "year")
      Stripe::Plan.stubs(:retrieve).returns(stripe_plan)

      expect(plan.subscription_interval).to eq "year"
      expect(Stripe::Plan).to have_received(:retrieve).with(plan.sku)
    end
  end

  describe "#fulfill" do
    it "starts a subscription" do
      subscription = build_stubbed(:subscription)
      subscription.stubs(update: nil)
      user = build_stubbed(:user)
      user.stubs(:create_subscription).returns(subscription)
      plan = build_stubbed(:plan)
      checkout = build_stubbed(:checkout, user: user, plan: plan)
      fulfillment = stub_subscription_fulfillment(checkout)

      plan.fulfill(checkout, user)

      expect(fulfillment).to have_received(:fulfill)
      expect(user).
        to have_received(:create_subscription).with(
          plan: plan,
          stripe_id: checkout.stripe_subscription_id
        )
    end
  end

  describe "#has_feature?" do
    it "returns true if the plan has the feature" do
      plan = build_stubbed(:plan, :includes_mentor)
      expect(plan).to have_feature(:mentor)
    end

    it "returns false if the plan does not have the feature" do
      plan = build_stubbed(:plan, :no_mentor)
      expect(plan).to_not have_feature(:mentor)
    end

    it "raises an exception with an invalid feature name" do
      plan = build_stubbed(:plan)
      expect{ plan.has_feature?(:foo) }.to raise_error
    end

    it "returns false when weekly iteration cannot access trails" do
      plan = build(:basic_plan)

      expect(plan).to_not have_feature(:exercises)
    end

    it "returns true when a plan can access trails" do
      plan = build(:plan)

      expect(plan).to have_feature(:exercises)
    end
  end

  describe "#annualized_payment" do
    it "returns the payment amount times 12" do
      plan = build_stubbed(:plan)

      expect(plan.annualized_payment).to eq(12 * plan.price)
    end
  end

  describe "#discounted_annual_payment" do
    it "returns the payment amount of the annual plan" do
      plan = build_stubbed(:plan, :with_annual_plan)

      expect(plan.discounted_annual_payment).to eq(990)
    end
  end

  describe "#annual_plan_sku" do
    it "returns the sku of associated annual plan" do
      plan = build_stubbed(:plan, :with_annual_plan)
      annual_plan = plan.annual_plan

      expect(plan.annual_plan_sku).to eq(annual_plan.sku)
    end
  end

  describe "#fulfill" do
    it "starts a subscription for a new team" do
      subscription = build_stubbed(:subscription)
      subscription.stubs(update: nil)
      user = build_stubbed(:user)
      user.stubs(:create_subscription).returns(subscription)
      plan = build_stubbed(:plan, :team)
      checkout = build_stubbed(:checkout, user: user, plan: plan)
      subscription_fulfillment = stub_subscription_fulfillment(checkout)
      team_fulfillment = stub_team_fulfillment(checkout)

      plan.fulfill(checkout, user)

      expect(subscription_fulfillment).to have_received(:fulfill)
      expect(team_fulfillment).to have_received(:fulfill)
      expect(user).
        to have_received(:create_subscription).with(
          plan: plan,
          stripe_id: checkout.stripe_subscription_id
        )
    end

    def stub_team_fulfillment(checkout)
      stub("team-fulfillment", :fulfill).tap do |fulfillment|
        TeamFulfillment.
          stubs(:new).
          with(checkout, checkout.user).
          returns(fulfillment)
      end
    end
  end

  describe "#has_annual_plan?" do
    it "returns false when the plan has no annual version" do
      plan = build_stubbed(:plan, annual_plan: nil)

      expect(plan.has_annual_plan?).to be false
    end

    it "returns true when the plan has annual version" do
      plan = build_stubbed(:plan, annual_plan: build_stubbed(:plan, :annual))

      expect(plan.has_annual_plan?).to be true
    end
  end

  def create_inactive_subscription_for(plan)
    create(:inactive_subscription, plan: plan)
  end

  def create_active_subscription_for(plan)
    create(:subscription, plan: plan)
  end
end
