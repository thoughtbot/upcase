require "rails_helper"

describe AnalyticsHelper do
  describe "#can_use_analytics?" do
    context "when an ENV['ANALYTICS'] value is present and not masquerading?" do
      it "returns true" do
        ClimateControl.modify ANALYTICS: "anything" do
          allow(helper).to receive(:masquerading?).and_return(false)

          expect(helper.can_use_analytics?).to eq(true)
        end
      end
    end

    context "when we're masquerading" do
      it "returns false" do
        allow(helper).to receive(:masquerading?).and_return(true)

        expect(helper.can_use_analytics?).to eq(false)
      end
    end

    context "when no ENV['ANALYTICS'] value is present" do
      it "returns false" do
        ClimateControl.modify ANALYTICS: nil do
          allow(helper).to receive(:masquerading?).and_return(false)

          expect(helper.can_use_analytics?).to eq(false)
        end
      end
    end
  end

  describe "#identify_hash" do
    it "returns a hash of data to be sent to analytics" do
      user = build_stubbed(:user, stripe_customer_id: "something")

      expect(identify_hash(user)).to eq(
        created: user.created_at,
        email: user.email,
        first_name: user.first_name,
        has_active_subscription: user.subscriber?,
        name: user.name,
        plan: user.plan_name,
        scheduled_for_deactivation_on: nil,
        stripe_customer_url: StripeCustomer.new(user).url,
        subscribed_at: user.subscribed_at,
        user_id: user.id,
        username: user.github_username,
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
