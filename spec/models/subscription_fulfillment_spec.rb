require 'spec_helper'

describe SubscriptionFulfillment do
  describe 'fulfill' do
    it 'adds a subscription to the user for a subscription purchase' do
      user = create(:user)
      purchase = build(
        :subscription_purchase,
        user: user
      )

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase).fulfill

      expect(user.subscription).not_to be_nil
    end

    it 'does not add subscription for a regular purchase' do
      user = create(:user)
      purchase = build(:book_purchase)

      expect(user.subscription).to be_nil

      SubscriptionFulfillment.new(purchase).fulfill

      expect(user.subscription).to be_nil
    end
  end
end
