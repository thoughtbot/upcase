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
      build_stubbed(:subscriber).tap do |user|
        if eligible_for_annual_upgrade
          allow(user).to receive(:plan).
            and_return(build_stubbed(:plan, :with_annual_plan))
          allow(user).to receive(:eligible_for_annual_upgrade?).
            and_return(true)
          allow(user).to receive(:has_active_subscription?).and_return(true)
        end
      end
    end
  end
end
