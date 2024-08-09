require "rails_helper"

describe Admin::MasqueradesController do
  context "as an admin" do
    it "masquerades as another user by id" do
      admin = build_user(type: :admin)
      user = build_user
      sign_in_as admin

      post :create, params: {user_id: user.id}

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
      expect(response).to redirect_to rails_admin_path
    end
  end

  context "as a non admin" do
    context "#create" do
      it "redirects to root path if not signed in" do
        post :create, params: {user_id: build_user.id}

        expect(response).to redirect_to root_path
      end

      it "redirects to root path if not an admin" do
        user = build_user
        sign_in_as user

        post :create, params: {user_id: build_user.id}

        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to root_path
      end
    end

    context "#destroy" do
      context "when not signed_in" do
        it "redirects to root path" do
          delete :destroy

          expect(response).to redirect_to root_path
        end
      end

      context "when not an admin" do
        it "redirects to root path" do
          user = build_user
          sign_in_as user

          delete :destroy

          expect(response).to redirect_to root_path
        end
      end

      context "when an admin" do
        it "removes the admin_id from the session" do
          admin = build_user(type: :admin)
          session[:admin_id] = admin.id
          sign_in_as admin

          delete :destroy

          expect(session[:admin_id]).to be nil
          expect(response).to redirect_to rails_admin_path
        end
      end
    end
  end

  def build_user(type: :user)
    user = build_stubbed(type)
    allow(User).to receive(:find).with(user.id).and_return(user)
    allow(User).to receive(:find).with(user.id.to_s).and_return(user)
    user
  end
end
