require 'spec_helper'

describe User do
  context "associations" do
    it { should have_many(:paid_purchases) }
    it { should have_many(:purchases) }
    it { should have_many(:completions) }
    it { should have_many(:notes).order('created_at DESC') }
    it { should belong_to(:mentor).class_name('User') }
    it { should have_many(:mentees).class_name('User') }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
  end

  context "#first_name" do
    it "has a first_name that is the first part of name" do
      user = User.new(name: "first last")
      expect(user.first_name).to eq "first"
    end
  end

  context "#last_name" do
    it "has a last_name that is the last part of name" do
      user = User.new(name: "first last")
      expect(user.last_name).to eq "last"
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

  describe '#subscribed_at' do
    it 'returns the date the user subscribed if the user has a subscription' do
      user = create(:user, :with_subscription)

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
      video_product = create(:video_product)
      subscription_purchase = SubscriberPurchase.new(video_product, user)
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

  describe '.mentors' do
    it 'includes only mentors' do
      user = create(:user)
      mentor = create(:user, available_to_mentor: true)

      expect(User.mentors).to include mentor
      expect(User.mentors).not_to include user
    end
  end

  describe '#assign_mentor' do
    it 'sets the given user as the mentor' do
      mentee = create(:user)
      mentor = create(:user, available_to_mentor: true)

      mentee.assign_mentor(mentor)

      expect(mentee.mentor).not_to be_nil
    end
  end

  describe '#mentor_name' do
    it 'returns mentor name if mentor exists' do
      mentee = build_stubbed(:user, :with_mentor)
      mentor = mentee.mentor

      expect(mentee.mentor_name).to eq mentor.name
    end

    it "returns nil if mentor doesn't exist" do
      user_without_a_mentor = build(:user)

      expect(user_without_a_mentor.mentor_name).to eq nil
    end
  end

  describe '.find_or_sample_mentor' do
    it 'returns a mentor for the given id' do
      mentor = create(:user)

      expect(User.find_or_sample_mentor(mentor.id)).to eq mentor
    end

    it 'returns a random mentor if one cannot be found with the given id' do
      mentor = create(:user, available_to_mentor: true)

      expect(User.find_or_sample_mentor(nil)).to eq mentor
    end
  end

  describe '#has_subscription_with_mentor?' do
    it 'returns true when the subscription includes mentoring' do
      plan = create(:plan, includes_mentor: true)
      subscription = create(:subscription, plan: plan)
      user = create(:user, subscription: subscription)

      expect(user.has_subscription_with_mentor?).to be_true
    end

    it 'returns false when the subscription does not include mentoring' do
      plan = create(:plan, includes_mentor: false)
      subscription = create(:subscription, plan: plan)
      user = create(:user, subscription: subscription)

      expect(user.has_subscription_with_mentor?).to be_false
    end

    it 'returns false when there is no subscription' do
      user = create(:user)

      expect(user.has_subscription_with_mentor?).to be_false
    end
  end

  describe '#plan_name' do
    it 'delegates to Subscription for the Plan name' do
      user = create(:user, :with_subscription)
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

  describe '#availability' do
    it "has a default" do
      user = User.new

      expect(user.availability).to eq '11am to 5pm on Fridays'
    end
  end

  describe '#mentor_email' do
    it "delegates to the user's mentor" do
      user = create(:user, :with_mentor)
      expect(user.mentor_email).to eq user.mentor.email
    end
  end
end
