require 'spec_helper'

describe NotesController do
  context 'create' do
    it 'redirects to the sign in page if visitor is not logged in' do
      sign_out

      post :create

      expect(response).to redirect_to sign_in_path
    end
  end
end
