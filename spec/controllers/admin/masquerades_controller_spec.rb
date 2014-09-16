require "rails_helper"

describe Admin::MasqueradesController do
  context "as an admin" do
    it "masquerades as another user by id" do
      admin = build_user(type: :admin)
      user = build_user
      sign_in_as admin

      post :create, user_id: user.id

      expect(controller.current_user).to eq(user)
      expect(session[:admin_id]).to eq(admin.id)
      expect(response).to redirect_to root_path
    end

    it "stops masquerading" do
      admin = build_user(type: :admin)
      user = build_user
      sign_in_as user
      session[:admin_id] = admin.id

      delete :destroy

      expect(controller.current_user).to eq(admin)
      expect(session[:admin_id]).to be(nil)
      expect(response).to redirect_to admin_path
    end
  end

  context "as a non admin" do
    context "#create" do
      it "redirects to root path if not signed in" do
        post :create, user_id: build_user.id

        expect(controller.current_user).to eq(nil)
        expect(response).to redirect_to root_path
      end

      it "redirects to root path if not an admin" do
        user = build_user
        sign_in_as user

        post :create, user_id: build_user.id

        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to root_path
      end
    end

    context "#destroy" do
      it "redirects to root path if not signed in" do
        delete :destroy

        expect(controller.current_user).to eq(nil)
        expect(response).to redirect_to root_path
      end

      it "redirects to root path if not an admin" do
        user = build_user
        sign_in_as user

        delete :destroy

        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  def build_user(type: :user)
    user = build_stubbed(type)
    User.stubs(:find).with(user.id).returns(user)
    User.stubs(:find).with(user.id.to_s).returns(user)
    user
  end
end
