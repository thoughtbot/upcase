require 'spec_helper'

describe NotesController do
  context 'create' do
    it 'redirects to the sign in page if visitor is not logged in' do
      sign_out

      post :create, user_id: 1

      expect(response).to redirect_to sign_in_path
    end

    it "redirects non-admin user if they try to post on another's timeline" do
      non_admin = create(:user, admin: false)
      another_user = create(:user)
      sign_in_as(non_admin)

      post :create, user_id: another_user.id, note: { body: 'Hi' }

      expect(response).to redirect_to timeline_path
    end
  end
end
