require 'spec_helper'

describe TimelinesController do
  context 'show' do
    it 'redirects to the sign in page if visitor is not logged in' do
      get :show

      expect(response).to redirect_to sign_in_path
    end

    it 'allows an admin to view the timeline of a mentee' do
      admin = create(:user, admin: true)
      mentee = create(:user)
      sign_in_as(admin)

      get :show, user_id: mentee

      expect(response).to be_success
    end

    it 'shows the timeline for the current user if no user id is available' do
      user = create(:user)
      sign_in_as(user)

      get :show

      expect(response).to be_success
    end
  end
end
