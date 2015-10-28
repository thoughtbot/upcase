require "rails_helper"

describe Checkout do
  it { should belong_to(:user) }
  it { should belong_to(:plan) }

  it { should validate_presence_of(:user) }

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
      stripe_subscription = double("stripe_subscription", create: false)
      allow(StripeSubscription).to receive(:new).
        and_return(stripe_subscription)
      checkout = build(:checkout)

      expect(checkout.fulfill).to be_falsey
    end

    it "sends a receipt" do
      checkout = build(:checkout)
      allow(SendCheckoutReceiptEmailJob).to receive(:enqueue)

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

    it "updates github_username on the user" do
      user = create(:user, github_username: "old")
      checkout = build(:checkout, user: user, github_username: "new")

      checkout.fulfill

      expect(user.github_username).to eq "new"
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
    it "uses the price of the plan as it's price" do
      plan = build(:plan, price_in_dollars: 50)
      checkout = build(:checkout, plan: plan)

      expect(checkout.price).to eq 50
    end

    it "uses the price of the plan and minimum quantity as it's price" do
      plan = build_stubbed(:plan, minimum_quantity: 3, price_in_dollars: 50)
      checkout = build(:checkout, plan: plan)

      expect(checkout.price).to eq 150
    end
  end

  context "#quantity" do
    it "is the minimum_quantity of the plan" do
      plan = build_stubbed(:plan, minimum_quantity: 3)
      checkout = build(:checkout, plan: plan)

      expect(checkout.quantity).to eq 3
    end
  end

  context "#coupon" do
    it "returns a coupon from stripe_coupon_id" do
      create(:coupon, code: "5OFF")
      checkout = build(:checkout, stripe_coupon_id: "5OFF")

      expect(checkout.coupon.code).to eq "5OFF"
    end
  end

  context "#needs_github_username?" do
    it "is false if the user has a valid github username" do
      user = build_stubbed(:user, github_username: "githubuser")
      checkout = build_stubbed(:checkout, user: user)

      expect(checkout.needs_github_username?).to be(false)
    end

    it "is true for new users without a github username" do
      user = build_stubbed(:user, github_username: nil)
      checkout = build_stubbed(:checkout, user: user)

      expect(checkout.needs_github_username?).to be(true)
    end

    it "is true if there is an error for the user's github_username field" do
      user = build_stubbed(:user, github_username: "user")
      allow(user).to receive(:errors).and_return([:github_username])
      checkout = build_stubbed(:checkout, user: user)

      expect(checkout.needs_github_username?).to be(true)
    end
  end
end
