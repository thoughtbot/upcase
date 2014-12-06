require "rails_helper"

describe AnnualBillingsController do
  describe "#new" do
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

    context "when not signed in" do
      it "redirects to the sign in page" do
        get :new

        expect(response).to redirect_to sign_in_path
      end
    end

    def subscriber(eligible_for_annual_upgrade:)
      build_stubbed(:subscriber).tap do |user|
        if eligible_for_annual_upgrade
          user.stubs(
            plan: build_stubbed(:plan, :with_annual_plan),
            eligible_for_annual_upgrade?: true,
            has_active_subscription?: true
          )
        end
      end
    end
  end
end
