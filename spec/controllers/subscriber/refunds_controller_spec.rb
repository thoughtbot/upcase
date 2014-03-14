require 'spec_helper'

describe Subscriber::RefundsController do
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
end
