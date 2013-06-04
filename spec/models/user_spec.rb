require 'spec_helper'

describe User do
  context "associations" do
    it { should have_many(:paid_purchases) }
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

  describe "#has_purchased?" do
    it "returns true if the user has any paid purchases" do
      user = build_stubbed(:user)
      user.stubs(:paid_purchases).returns([stub])

      user.should have_purchased
    end

    it "returns false if the user has no purchases" do
      user = build_stubbed(:user)
      user.stubs(:purchases).returns([stub])
      user.should_not have_purchased
    end
  end

  context '#inactive_subscription' do
    it "returns the user's associated subscription if it is inactive" do
      user = User.new
      subscription = user.subscription = build_stubbed(:inactive_subscription)
      expect(user.inactive_subscription).to be subscription
    end

    it "returns nil if the user's associated subscription is active" do
      user = User.new
      subscription = user.subscription = build_stubbed(:active_subscription)
      expect(user.inactive_subscription).to be nil
    end

    it "returns nil if the user doesn't even have a subscription" do
      user = User.new
      expect(user.inactive_subscription).to be nil
    end
  end

  context '#has_active_subscription?' do
    it "returns true if the user's associated subscription is active" do
      user = User.new
      user.subscription = build_stubbed(:active_subscription)
      expect(user).to have_active_subscription
    end

    it "returns false if the user's associated subscription is not active" do
      user = User.new
      user.subscription = build_stubbed(:inactive_subscription)
      expect(user).not_to have_active_subscription
    end

    it "returns false if the user doesn't even have a subscription" do
      user = User.new
      expect(user).not_to have_active_subscription
    end
  end

  context "when there are previous purchases" do
    let(:email) { "newuser@example.com" }

    before do
      @prev_purchases = [create(:purchase, email: email, stripe_customer_id: "stripecustomer"),
                         create(:purchase, email: email, stripe_customer_id: nil, payment_method: "paypal")]
      @other_purchase = create(:purchase)
    end

    it "associates only purchases for a new user with the same email" do
      user = create(:user, email: email)
      user.purchases.should =~ @prev_purchases
      user.purchases.should_not include @other_purchase
    end

    it "retrieves the stripe customer id from previous purchases" do
      user = create(:user, email: email)
      user.reload.stripe_customer_id.should == "stripecustomer"
    end
  end

  context "when there are no previous purchases" do
    it "doesn't associate a created user with any purchases" do
      user = create(:user)
      user.purchases.should be_empty
      user.stripe_customer_id.should be_blank
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

    def stub_team_member(value)
      client = stub('github_client')
      client.
        stubs(:team_member?).
        with(User::THOUGHTBOT_TEAM_ID, 'thoughtbot').
        returns(value)
      Octokit::Client.
        stubs(:new).
        with(login: GITHUB_USER, password: GITHUB_PASSWORD).
        returns(client)
    end

    it "creates a new user when no matching user" do
      stub_team_member false
      user = User.find_or_create_from_auth_hash(auth_hash)
      user.should be_persisted
      user.first_name.should == 'Test'
      user.last_name.should == 'User'
      user.email.should == 'user@example.com'
      user.github_username.should == 'thoughtbot'
      user.auth_provider.should == 'github'
      user.auth_uid.should == 1
      user.should_not be_admin
    end

    it "creates a new admin when no matching user from our organization" do
      stub_team_member true
      user = User.find_or_create_from_auth_hash(auth_hash)
      user.should be_admin
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

  context "has_conflict?" do
    it "returns false of the passed in purchaseable is not a section" do
      user = create(:user)
      create(:paid_purchase, user: user)
      create(:online_section_purchase, user: user)

      expect(user.has_conflict?(create(:product))).to be_false
    end

    it 'returns false if trying to register for an ongoing section with no conflict' do
      user = create(:user)
      online_section = create(:online_section, starts_on: 30.days.ago, ends_on: 20.days.ago)
      create(:online_section_purchase, user: user, purchaseable: online_section, created_at: 26.days.ago)
      new_online_section = create(:online_section, starts_on: 22.days.ago.to_date, ends_on: nil)

      expect(user.has_conflict?(new_online_section)).to be_false
    end
  end

  context 'password validations' do
    it 'allows non-oauth users to update attributes without the password' do
      user = create_user_without_cached_password(admin: false)

      user.admin = true
      user.save

      user.reload.should be_admin
    end

    def create_user_without_cached_password(attributes)
      user = create(:user, attributes)
      User.find(user.id)
    end
  end

  describe '#subscription_purchases' do
    it 'includes only subscription purchases' do
      subscription = create(:active_subscription)
      user = subscription.user
      create_subscription_purchase(user)
      create_paid_purchase(user)

      user.paid_purchases.count.should eq 2
      user.subscription_purchases.count.should eq 1
    end

    def create_subscription_purchase(user)
      video_product = create(:video_product)
      subscription_purchase = SubscriberPurchase.new(video_product, user)
      subscription_purchase.create
    end

    def create_paid_purchase(user)
      create(:book_purchase, user: user)
    end
  end
end
