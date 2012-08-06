require 'spec_helper'

describe User do
  context "associations" do
    it { should have_many(:purchases) }
  end

  context "validations" do
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:first_name) }
  end

  context "#name" do
    it "has a name that is the first and last name" do
      user = User.new(first_name: "first", last_name: "last")
      user.name.should == "first last"
    end
  end

  context "when there are previous purchases" do
    let(:email) { "newuser@example.com" }

    before do
      @prev_purchases = [create(:purchase, email: email, stripe_customer: "stripecustomer"),
                         create(:purchase, email: email, stripe_customer: nil, payment_method: "paypal")]
      @other_purchase = create(:purchase)
    end

    it "associates only purchases for a new user with the same email" do
      user = create(:user, email: email)
      user.purchases.should =~ @prev_purchases
      user.purchases.should_not include @other_purchase
    end

    it "retrieves the stripe customer id from previous purchases" do
      user = create(:user, email: email)
      user.reload.stripe_customer.should == "stripecustomer"
    end
  end

  context "when there are no previous purchases" do
    it "doesn't associate a created user with any purchases" do
      user = create(:user)
      user.purchases.should be_empty
      user.stripe_customer.should be_blank
    end
  end
end
