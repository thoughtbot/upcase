require "rails_helper"

describe CouponsController do
  describe "#show" do
    context "with valid coupon" do
      it "should set a valid coupon in the session" do
        create(:coupon, code: "5OFF")

        get :show, params: { id: "5OFF" }

        expect(session[:coupon]).to eq("5OFF")
        expect(flash[:notice]).to(
          eq I18n.t("coupons.flashes.success", code: "5OFF")
        )
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid coupon" do
      it "should not set a coupon in session" do
        get :show, params: { id: "5OFF" }

        expect(session[:coupon]).to be_nil
        expect(flash[:error]).to eq I18n.t("coupons.flashes.invalid")
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
