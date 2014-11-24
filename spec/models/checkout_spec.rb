require "rails_helper"

describe Checkout do
  it { should belong_to(:user) }
  it { should belong_to(:plan) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:github_username) }

  it { should delegate(:plan_includes_team?).to(:plan).as(:includes_team?) }
  it { should delegate(:plan_name).to(:plan).as(:name) }
  it { should delegate(:plan_sku).to(:plan).as(:sku) }
  it { should delegate(:plan_terms).to(:plan).as(:terms) }
  it { should delegate(:user_email).to(:user).as(:email) }

  context "#fulfill" do
    it "fulfills a subscription when purchasing a plan" do
      checkout = build(:checkout)
      fulfillment = stub_subscription_fulfillment(checkout)

      checkout.fulfill

      expect(fulfillment).to have_received(:fulfill)
    end

    it "creates a subscription with proper stripe_id" do
      checkout = build(:checkout)

      checkout.fulfill
      result = checkout.user.subscription.stripe_id

      expect(result).to eq(FakeStripe::SUBSCRIPTION_ID)
    end

    it "does not fulfill with a bad credit card" do
      stripe_subscription = stub("stripe_subscription", create: false)
      StripeSubscription.stubs(:new).returns(stripe_subscription)
      checkout = build(:checkout)

      expect(checkout.fulfill).to be_falsey
    end

    it "sends a receipt" do
      checkout = build(:checkout)
      SendCheckoutReceiptEmailJob.stubs(:enqueue)

      checkout.fulfill

      expect(SendCheckoutReceiptEmailJob).
        to have_received(:enqueue).with(checkout.id)
    end

    it "copies checkout info to the user" do
      user = create(:user, :with_github)
      checkout = build(:checkout, user: user, organization: "The thoughtbot")

      checkout.fulfill

      expect(user.organization).to eq("The thoughtbot")
    end

    it "creates a user when fulfilled with a password" do
      checkout = build(:checkout, user: nil, github_username: "cpytel")
      checkout.password = "test"

      checkout.fulfill

      expect(checkout.user).to be_persisted
    end

    it "saves github_username to the user" do
      user = create(:user, github_username: nil)
      checkout = build(:checkout, user: user, github_username: "tbot")

      checkout.fulfill

      expect(user.github_username).to eq "tbot"
    end

    it "requires a unique GitHub username if there is no user" do
      create :user, github_username: "taken"
      checkout = build(:checkout, user: nil, github_username: "taken")

      checkout.fulfill

      expect(checkout.errors.full_messages).
        to include("Github username has already been taken")
    end

    it "requires a unique github_username for existing user" do
      create(:user, github_username: "taken")
      user = create(:user)
      checkout = build(:checkout, user: user, github_username: "taken")

      checkout.fulfill

      expect(checkout.errors.full_messages).
        to include("Github username has already been taken")
    end
  end

  context "#price" do
    it "uses the individual_price of the plan as it's price" do
      plan = build(:plan, individual_price: 50)
      checkout = build(:checkout, plan: plan)

      expect(checkout.price).to eq 50
    end

    it "uses the individual_price of the plan and quantity as it's price" do
      plan = build(:plan, individual_price: 50)
      checkout = build(:checkout, plan: plan, quantity: 3)

      expect(checkout.price).to eq 150
    end
  end
end
