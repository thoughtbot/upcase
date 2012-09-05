require 'spec_helper'

describe User do
  context "associations" do
    it { should have_many(:purchases) }
    it { should have_many(:registrations) }
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

  context "when there are previous registrations" do
    let(:email) { "newuser@example.com" }

    before do
      @prev_registrations = [create(:registration, email: email),
                             create(:registration, email: email)]
      @other_registration = create(:registration)
    end

    it "associates only registrations for a new user with the same email" do
      user = create(:user, email: email)
      user.registrations.should =~ @prev_registrations
      user.registrations.should_not include @other_registration
    end
  end

  context "when there are no previous registrations" do
    it "doesn't associate a created user with any purchases" do
      user = create(:user)
      user.registrations.should be_empty
    end
  end

  context "#find_or_create_from_auth_hash" do
    let(:auth_hash) do
      {
        'provider' => 'github',
        'uid' => 1,
        'info' => {
          'email' => 'user@example.com',
          'name' => 'Test User',
          'nickname' => 'thoughtbot',
        }
      }
    end

    it "creates a new user when no matching user" do
      user = User.find_or_create_from_auth_hash(auth_hash)
      user.should be_persisted
      user.first_name.should == 'Test'
      user.last_name.should == 'User'
      user.email.should == 'user@example.com'
      user.github_username.should == 'thoughtbot'
      user.auth_provider.should == 'github'
      user.auth_uid.should == 1
    end

    context "with an existing user" do
      before do
        @existing_user = create(:user, auth_provider: 'github', auth_uid: 1)
      end

      it "finds the user" do
        @existing_user.should == User.find_or_create_from_auth_hash(auth_hash)
      end
    end
  end
end
