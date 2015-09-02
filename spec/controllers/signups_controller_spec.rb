require "rails_helper"

include StubCurrentUserHelper

describe SignupsController do
  describe "#create" do
    context "when the charge succeeds" do
      it "sets the flash with the purchase amount (to notify Segment)" do
        stub_current_user_with(create(:user))
        plan = create(:plan)

        get :create

        expect(flash[:purchase_amount]).to eq(plan.price_in_dollars)
      end
    end
  end
end
