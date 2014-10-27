require "rails_helper"

describe AnalyticsHelper do
  describe '#analytics?' do
    it "is true when ENV['ANALYTICS'] is present" do
      ENV["ANALYTICS"] = "anything"

      expect(helper).to be_analytics

      ENV["ANALYTICS"] = nil
    end

    it "is false when ENV['ANALYTICS'] is not present" do
      ENV["ANALYTICS"] = nil

      expect(helper).to_not be_analytics
    end
  end

  describe "#analytics_hash" do
    it "returns a hash of data to be sent to analytics" do
      user = build_stubbed(:user, stripe_customer_id: "something")

      expect(analytics_hash(user)).to eq(
        created: user.created_at,
        email: user.email,
        has_active_subscription: user.has_active_subscription?,
        has_logged_in_to_forum: user.has_logged_in_to_forum?,
        mentor_name: user.mentor_name,
        name: user.name,
        plan: user.plan_name,
        scheduled_for_cancellation_on: nil,
        stripe_customer_url: StripeCustomer.new(user).url,
        subscribed_at: user.subscribed_at,
        username: user.github_username,
        user_id: user.id,
      )
    end
  end

  describe "#purchased_hash" do
    it "tracks the purchase amount" do
      purchase_amount = "29.00"
      flash[:purchase_amount] = purchase_amount

      expect(purchased_hash[:revenue]).to eq(purchase_amount)
    end

    context "without campaign params" do
      it "tracks nil" do
        expect(purchased_hash[:context]).to eq(campaign: nil)
      end
    end

    context "with campaign params" do
      it "tracks the campaign params" do
        campaign_params = {
          utm_source: "twitter",
          utm_medium: "twitter-ads",
          utm_campaign: "e123a"
        }
        session[:campaign_params] = campaign_params

        expect(purchased_hash[:context]).to eq(campaign: campaign_params)
      end
    end
  end
end
