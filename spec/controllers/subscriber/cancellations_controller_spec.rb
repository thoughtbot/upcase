require 'spec_helper'

describe Subscriber::CancellationsController, type: :controller do
  describe '#new without being signed in' do
    it 'redirects to sign in page' do
      get :new

      expect(response).to redirect_to sign_in_path
    end
  end

  describe '#create without being signed in' do
    it 'redirects to sign in page' do
      post :create

      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#create" do
    it "redirects to the account page" do
      subscription = create(:subscription)
      sign_in_as(subscription.user.reload)

      post :create

      expect(response).to redirect_to my_account_path
    end
  end
end
