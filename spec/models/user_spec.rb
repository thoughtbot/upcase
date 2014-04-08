require 'spec_helper'

describe User do
  context "associations" do
    it { should have_many(:paid_purchases) }
    it { should have_many(:purchases) }
    it { should have_many(:completions) }
    it { should have_many(:notes).order('created_at DESC') }
    it { should belong_to(:mentor) }
    it { should have_many(:public_keys).dependent(:destroy) }
    it { should belong_to(:team) }
    it { should have_one(:purchased_subscription).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
  end

  context 'with a subscription that includes a mentor' do
    it 'is invalid without a mentor' do
      plan = create(:plan, includes_mentor: true)
      subscription = create(:subscription, plan: plan)
      user = create(:user, :with_mentor, subscription: subscription)

      expect(user).to validate_presence_of(:mentor_id)
    end
  end

  context "#first_name" do
    it "has a first_name that is the first part of name" do
      user = User.new(name: "first last")
      expect(user.first_name).to eq "first"
    end
  end

  context '#last_name' do
    it 'returns everything except the first name' do
      user = User.new(name: 'First Last')
      expect(user.last_name).to eq 'Last'

      user_with_multi_part_last_name = User.new(name: 'First van der Last')
      expect(user_with_multi_part_last_name.last_name).to eq 'van der Last'
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
      subscription = build_stubbed(:inactive_subscription)
      user.purchased_subscription = subscription
      expect(user.inactive_subscription).to be subscription
    end

    it "returns nil if the user's associated subscription is active" do
      user = User.new
      subscription = build_stubbed(:active_subscription)
      user.purchased_subscription = subscription
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
      user.purchased_subscription = build_stubbed(:active_subscription)
      expect(user).to have_active_subscription
    end

    it "returns true with an active team subscription" do
      team = Teams::Team.new
      team.subscription = build_stubbed(:active_subscription)
      user = User.new
      user.team = team
      expect(user).to have_active_subscription
    end

    it "returns false with an inactive team subscription" do
      team = Teams::Team.new
      team.subscription = build_stubbed(:inactive_subscription)
      user = User.new
      user.team = team
      expect(user).not_to have_active_subscription
    end

    it "returns false if the user's associated subscription is not active" do
      user = User.new
      user.purchased_subscription = build_stubbed(:inactive_subscription)
      expect(user).not_to have_active_subscription
    end

    it "returns false if the user doesn't even have a subscription" do
      user = User.new
      expect(user).not_to have_active_subscription
    end
  end

  describe '#subscribed_at' do
    it 'returns the date the user subscribed if the user has a subscription' do
      user = create(:subscriber)

      expect(user.subscribed_at).to eq user.subscription.created_at
    end

    it 'returns nil when the user does not have a subscription' do
      user = create(:user)

      expect(user.subscribed_at).to be_nil
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

  context '#notes' do
    it 'returns only the users notes and no others' do
      user = create(:user)
      another_user = create(:user)
      create(:note, user: another_user)

      note = create(:note, user: user)

      expect(user.notes).to eq [note]
    end

    it 'returns items sorted DESC by creation_date' do
      user = create(:user)

      oldest_item = create(:note, user: user)
      middle_item = create(:note, user: user)
      newest_item = create(:note, user: user)

      expect(user.notes).to eq [newest_item, middle_item, oldest_item]
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
      screencast = create(:screencast)
      subscription_purchase = SubscriberPurchase.new(screencast, user)
      subscription_purchase.create
    end

    def create_paid_purchase(user)
      create(:book_purchase, user: user)
    end
  end

  describe '#paid_products' do
    it 'includes purchased products with no subscription plans' do
      user = create(:user, :with_mentor, :with_github)
      book_purchase = create(:book_purchase, user: user)
      prime_plan = create(:plan_purchase, user: user)

      expect(user.paid_products).to eq [book_purchase]
    end
  end

  describe '#ordered_paid_products' do
    it 'returns paid products ordered by creation date' do
      user = create(:user)
      purchase_two = create(
        :paid_purchase,
        user: user,
        created_at: 5.minutes.ago
      )
      purchase_one = create(
        :paid_purchase,
        user: user,
        created_at: 1.minutes.ago
      )

      expect(user.ordered_paid_products).to eq([purchase_one, purchase_two])
    end
  end

  describe '#credit_card' do
    it 'returns nil if there is no stripe_customer_id' do
      user = create(:user, stripe_customer_id: nil)

      expect(user.credit_card).to be_nil
    end

    it 'returns the active card for the stripe customer' do
      user = create(:user, stripe_customer_id: FakeStripe::CUSTOMER_ID)

      expect(user.credit_card).not_to be_nil
      expect(user.credit_card['last4']).to eq '1234'
    end
  end

  describe '#assign_mentor' do
    it 'sets the given user as the mentor' do
      mentee = create(:user)
      mentor = create(:mentor)

      mentee.assign_mentor(mentor)

      expect(mentee.mentor).not_to be_nil
    end
  end

  describe '#has_subscription_with_mentor?' do
    it 'returns true when the subscription includes mentoring' do
      plan = build(:plan, includes_mentor: true)
      subscription = build(:subscription, plan: plan)
      user = build(:user, :with_mentor, subscription: subscription)

      expect(user.has_subscription_with_mentor?).to be_true
    end

    it 'returns false when the subscription does not include mentoring' do
      plan = build(:plan, includes_mentor: false)
      subscription = build(:subscription, plan: plan)
      user = build(:user, subscription: subscription)

      expect(user.has_subscription_with_mentor?).to be_false
    end

    it 'returns false when the subscription is inactive' do
      plan = build(:plan, includes_mentor: true)
      subscription = build(:inactive_subscription, plan: plan)
      user = build(:user, :with_mentor, subscription: subscription)

      expect(user.has_subscription_with_mentor?).to be_false
    end

    it 'returns false when there is no subscription' do
      user = build(:user)

      expect(user.has_subscription_with_mentor?).to be_false
    end
  end

  describe '#plan_name' do
    it 'delegates to Subscription for the Plan name' do
      user = create(:subscriber)
      expect(user.plan_name).to eq user.subscription.plan.name
    end

    it 'returns nil when there is no Subscription' do
      user = create(:user)
      expect(user.plan_name).to be_nil
    end
  end

  describe '#has_logged_in_to_forum?' do
    it 'returns true when the user has logged in to the forum' do
      user = User.new
      OauthAccessToken.stubs(:for_user).with(user).returns(true)

      expect(user.has_logged_in_to_forum?).to eq true
    end

    it 'returns false when the user has never logged in to the forum' do
      user = User.new
      OauthAccessToken.stubs(:for_user).with(user).returns(nil)

      expect(user.has_logged_in_to_forum?).to eq false
    end
  end

  describe '#mentor_name' do
    it 'returns the mentor name' do
      mentee = build_stubbed(:user, :with_mentor)
      mentor = mentee.mentor

      expect(mentee.mentor_name).to eq mentor.name
    end

    it 'returns nil if the user has no mentor' do
      user = build_stubbed(:user)

      expect(user.mentor_name).to be_nil
    end
  end

  describe '#mentor_email' do
    it "delegates to the user's mentor" do
      user = create(:user, :with_mentor)
      expect(user.mentor_email).to eq user.mentor.email
    end

    it 'returns nil if the user has no mentor' do
      user = build_stubbed(:user)

      expect(user.mentor_email).to be_nil
    end
  end

  describe '#mentor_first_name' do
    it "delegates to the user's mentor" do
      user = create(:user, :with_mentor)
      expect(user.mentor_first_name).to eq user.mentor.first_name
    end

    it 'returns nil if the user has no mentor' do
      user = build_stubbed(:user)

      expect(user.mentor_first_name).to be_nil
    end
  end

  describe '#has_access_to_shows?' do
    context 'when the user has an active subscription' do
      it 'returns true' do
        subscription = build_stubbed(:subscription)
        subscription.stubs(:active?).returns(true)
        user = build_stubbed(:user, subscription: subscription)

        expect(user).to have_access_to_shows
      end
    end

    context 'when the user has an inactive subscription' do
      it 'returns true' do
        subscription = build_stubbed(:subscription)
        subscription.stubs(:active?).returns(false)
        user = build_stubbed(:user, subscription: subscription)

        expect(user).not_to have_access_to_shows
      end
    end

    context 'when the user does not have a subscription' do
      it 'returns false' do
        user = build_stubbed(:user)

        expect(user).not_to have_access_to_shows
      end
    end
  end

  describe '#has_access_to_workshops?' do
    context 'when the user does not have a subscription' do
      it 'returns false' do
        user = build_stubbed(:user)

        expect(user.has_access_to_workshops?).to_not be
      end
    end

    context 'when the user has an inactive subscription' do
      it 'returns false' do
        user = create(:subscriber)
        user.subscription.stubs(:active?).returns(false)

        expect(user.has_access_to_workshops?).to_not be
      end
    end

    context 'when the user has an active subscription' do
      it "delegates to the subscription's includes_workshops? method" do
        user = create(:subscriber)
        user.subscription.stubs(:includes_workshops?).returns('expected')

        expect(user.has_access_to_workshops?).to eq 'expected'
      end
    end
  end

  describe '#subscription' do
    it 'returns a purchased subscription' do
      subscription = build_stubbed(:subscription)
      user = User.new
      user.purchased_subscription = subscription

      expect(user.subscription).to eq(subscription)
    end

    it 'returns a team subscription' do
      team = Teams::Team.new
      team.subscription = build_stubbed(:subscription)
      user = User.new
      user.team = team

      expect(user.subscription).to eq(team.subscription)
    end

    it 'returns nil without a subscription' do
      user = User.new

      expect(user.subscription).to be_nil
    end
  end

  describe '.with_active_subscription' do
    it 'returns users with active subscriptions' do
      with_active_subscription = create(:user, name: 'active')
      with_inactive_subscription = create(:user, name: 'inactive')
      create(:user, name: 'without subscription')
      create(:active_subscription, user: with_active_subscription)
      create(:inactive_subscription, user: with_inactive_subscription)

      result = User.with_active_subscription

      expect(result.map(&:name)).to eq(%w(active))
    end

    it 'eager loads individual subscriptions' do
      expect { User.with_active_subscription.map(&:plan_name) }.
        to eager_load { create(:active_subscription) }
    end

    it 'eager loads team subscriptions' do
      expect { User.with_active_subscription.map(&:plan_name) }.
        to eager_load { create_user_with_team }
    end

    def create_user_with_team
      owner = create(:user, :with_github)
      subscription = create(:active_subscription, user: owner)
      team = create(:team, subscription: subscription)
      create(:user, team: team)
    end
  end
end
