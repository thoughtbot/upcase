require "rails_helper"

describe AnalyticsHelper do
  describe '#analytics?' do
    it "is true when ENV['ANALYTICS'] is present" do
      ENV['ANALYTICS'] = 'anything'

      expect(helper).to be_analytics

      ENV['ANALYTICS'] = nil
    end

    it "is false when ENV['ANALYTICS'] is not present" do
      ENV['ANALYTICS'] = nil

      expect(helper).to_not be_analytics
    end
  end

  describe '#analytics_hash' do
    it 'returns a hash of data to be sent to analytics' do
      user = build_stubbed(:user, stripe_customer_id: 'something')

      expect(analytics_hash(user)).to eq(
        created: user.created_at,
        email: user.email,
        has_active_subscription: user.has_active_subscription?,
        has_logged_in_to_forum: user.has_logged_in_to_forum?,
        mentor_name: user.mentor_name,
        name: user.name,
        plan: user.plan_name,
        subscribed_at: user.subscribed_at,
        username: user.github_username,
        stripe_customer_url: StripeCustomer.new(user).url
      )
    end
  end
end
