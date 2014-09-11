require "rails_helper"

describe Admin::MasqueradesController do
  let(:user) { create(:user) }

  context "as an admin" do
    let(:admin) { create(:admin) }

    it "masquerades as another user by id" do
      sign_in_as admin

      post :create, user_id: user.id

      expect(@controller.current_user).to eq(user)
      expect(@controller.session[:admin_id]).to eq(admin.id)
      expect(@controller.send(:masquerading?)).to be(true)
      expect(response).to redirect_to root_path
    end

    it "stops masquerading" do
      sign_in_as user
      @controller.session[:admin_id] = admin.id

      delete :destroy

      expect(@controller.current_user).to eq(admin)
      expect(@controller.session[:admin_id]).to be(nil)
      expect(@controller.send(:masquerading?)).to be(false)
      expect(response).to redirect_to admin_path
    end
  end

  context "as a non admin" do
    context "#create" do
      it "redirects to root path if not signed in" do
        post :create, user_id: 0

        expect(@controller.current_user).to eq(nil)
        expect(response).to redirect_to root_path
      end

      it "redirects to root path if not an admin" do
        sign_in_as user

        post :create, user_id: 0

        expect(@controller.current_user).to eq(user)
        expect(response).to redirect_to root_path
      end
    end

    context "#destroy" do
      it "redirects to root path if not signed in" do
        delete :destroy

        expect(@controller.current_user).to eq(nil)
        expect(response).to redirect_to root_path
      end

      it "redirects to root path if not an admin" do
        sign_in_as user

        delete :destroy

        expect(@controller.current_user).to eq(user)
        expect(response).to redirect_to root_path
      end
    end
  end
end
