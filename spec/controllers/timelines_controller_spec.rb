require 'spec_helper'

describe TimelinesController do
  context 'show' do
    it 'redirects to the sign in page if visitor is not logged in' do
      sign_out

      get :show

      expect(response).to redirect_to sign_in_path
    end
  end
end
