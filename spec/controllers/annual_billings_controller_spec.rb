require "rails_helper"

describe AnnualBillingsController do
  describe "#new" do
    it { requires_signed_in_user_to { get :new } }

    context "when subscriber is eligible for an upgrade" do
      it "does not redirect to the root page" do
        sign_in_as subscriber(eligible_for_annual_upgrade: true)

        get :new

        expect(response).to be_success
      end
    end

    context "when subscriber is not eligible for an upgrade" do
      it "redirects to the root page" do
        sign_in_as subscriber(eligible_for_annual_upgrade: false)

        get :new

        expect(response).to redirect_to root_path
      end
    end

    def subscriber(eligible_for_annual_upgrade:)
      plan = if eligible_for_annual_upgrade
              create(:plan, :with_annual_plan)
            else
              create(:plan)
            end

      subscription = create(:subscription, plan: plan)
      subscription.user
    end
  end
end
