require 'rails_helper'

describe Checkout, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:subscribeable) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:github_username) }

  it { should delegate(:user_email).to(:user).as(:email) }
  it { should delegate(:user_first_name).to(:user).as(:first_name) }
  it { should delegate(:user_last_name).to(:user).as(:last_name) }
  it { should delegate(:user_github_username).to(:user).as(:github_username) }
  it { should delegate(:subscribeable_sku).to(:subscribeable).as(:sku) }
  it { should delegate(:subscribeable_name).to(:subscribeable).as(:name) }
  it { should delegate(:terms).to(:subscribeable) }

  context "#save" do
    it "fulfills a subscription when purchasing a plan" do
      checkout = build(:checkout)
      fulfillment = stub_subscription_fulfillment(checkout)

      checkout.save!

      expect(fulfillment).to have_received(:fulfill)
    end

    it "does not save with a bad credit card" do
      stripe_subscription = stub("stripe_subscription", create: false)
      StripeSubscription.stubs(:new).returns(stripe_subscription)
      checkout = build(:checkout)

      expect(checkout.save).to be false
    end

    it "sends a receipt" do
      checkout = build(:checkout)
      SendCheckoutReceiptEmailJob.stubs(:enqueue)

      checkout.save!

      expect(SendCheckoutReceiptEmailJob).
        to have_received(:enqueue).with(checkout.id)
    end

    it "copies checkout info to the user" do
      checkout_info_copier_stub = stub("payment_info_copier", copy_info_to_user: true)
      CheckoutInfoCopier.stubs(new: checkout_info_copier_stub)
      user = create(:user, :with_github)
      checkout = build(:checkout, user: user)
      expect(checkout_info_copier_stub).to have_received(:copy_info_to_user).never

      checkout.save

      expect(CheckoutInfoCopier).to have_received(:new).with(checkout, checkout.user)
      expect(checkout_info_copier_stub).to have_received(:copy_info_to_user)
    end

    it "requires a password if there is no user" do
      checkout = build(:checkout, user: nil)
      checkout.password = ""

      checkout.save

      expect(checkout.errors[:password]).to include "can't be blank"
    end

    it "creates a user when saved with a password" do
      checkout = build(:checkout, user: nil, github_username: "cpytel")
      checkout.password = "test"

      checkout.save!

      expect(checkout.user).to be_persisted
    end
  end

  it "uses the individual_price of the subscribeable as it's price" do
    plan = build(:individual_plan, individual_price: 50)
    checkout = build(:checkout, subscribeable: plan)

    expect(checkout.price).to eq 50
  end

  it "uses the individual_price of the subscribeable and quantity as it's price" do
    plan = build(:individual_plan, individual_price: 50)
    checkout = build(:checkout, subscribeable: plan, quantity: 3)

    expect(checkout.price).to eq 150
  end

  describe "#success_url" do
    it "delegates to its subscribeable" do
      controller = stub("controller")
      after_checkout_url = "http://example.com/after_checkout"
      plan = build_stubbed(:individual_plan)
      checkout = build_stubbed(:checkout, subscribeable: plan)
      plan.
        stubs(:after_checkout_url).
        with(controller, checkout).
        returns(after_checkout_url)

      expect(checkout.success_url(controller)).to eq(after_checkout_url)
    end
  end
end
