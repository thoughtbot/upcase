require "rails_helper"

describe Checkout do
  it { should belong_to(:user) }
  it { should belong_to(:plan) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:github_username) }

  it { should delegate(:user_email).to(:user).as(:email) }
  it { should delegate(:user_first_name).to(:user).as(:first_name) }
  it { should delegate(:user_last_name).to(:user).as(:last_name) }
  it { should delegate(:user_github_username).to(:user).as(:github_username) }
  it { should delegate(:plan_sku).to(:plan).as(:sku) }
  it { should delegate(:plan_name).to(:plan).as(:name) }
  it { should delegate(:terms).to(:plan) }

  context "#fulfill" do
    it "fulfills a subscription when purchasing a plan" do
      checkout = build(:checkout)
      fulfillment = stub_subscription_fulfillment(checkout)

      checkout.fulfill

      expect(fulfillment).to have_received(:fulfill)
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
      checkout_info_copier_stub = stub("payment_info_copier", copy_info_to_user: true)
      CheckoutInfoCopier.stubs(new: checkout_info_copier_stub)
      user = create(:user, :with_github)
      checkout = build(:checkout, user: user)
      expect(checkout_info_copier_stub).to have_received(:copy_info_to_user).never

      checkout.fulfill

      expect(CheckoutInfoCopier).to have_received(:new).with(checkout, checkout.user)
      expect(checkout_info_copier_stub).to have_received(:copy_info_to_user)
    end

    it "requires a unique GitHub username if there is no user" do
      create :user, github_username: "taken"
      checkout =
        build(:checkout, user: nil, github_username: "taken", password: "test")

      checkout.fulfill

      expect(checkout.errors.full_messages).
        to include("Github username has already been taken")
    end

    it "creates a user when fulfilled with a password" do
      checkout = build(:checkout, user: nil, github_username: "cpytel")
      checkout.password = "test"

      checkout.fulfill

      expect(checkout.user).to be_persisted
    end
  end

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
