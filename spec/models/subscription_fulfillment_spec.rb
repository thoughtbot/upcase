require 'spec_helper'

describe SubscriptionFulfillment do
  describe 'fulfill' do
    it 'adds a subscription to the user for a subscription purchase' do
      create_mentors
      user = create(:user)
      purchase = build(:plan_purchase, user: user)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase).fulfill

      expect(user.subscription).not_to be_nil
      expect(user.subscription.plan).to eq purchase.purchaseable
    end

    it 'does not add subscription for a regular purchase' do
      user = create(:user)
      purchase = build(:book_purchase)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase).fulfill

      expect(user.subscription).to be_nil
    end

    it 'assigns a mentor on creation' do
      create_mentors
      mentor = User.mentors.first
      user = create(:user)
      purchase = build(:plan_purchase, user: user, mentor_id: mentor.id)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase).fulfill

      expect(user.mentor).not_to be_nil
    end
  end
end
