require 'spec_helper'

describe Subscriber::CancellationsController do
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

  describe '#create with a subscription that has been charged' do
    it 'redirects to the refund page' do
      subscription = create(:subscription)
      sign_in_as(subscription.user.reload)

      post :create

      expect(response).to redirect_to new_subscriber_refund_path
    end
  end

  describe '#create with a subscription that has never been charged' do
    it 'redirects to the account page' do
      user = build_stubbed(:user)
      subscription = stub(last_charge: nil)
      user.stubs(subscription: subscription)
      Cancellation.stubs(:new).returns(stub(schedule: nil))
      sign_in_as(user)

      post :create

      expect(Cancellation).to have_received(:new)
        .with(subscription)
      expect(subscription).to have_received(:last_charge)
      expect(response).to redirect_to my_account_path
    end
  end
end
