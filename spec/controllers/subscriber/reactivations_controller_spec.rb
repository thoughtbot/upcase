require "rails_helper"

describe Subscriber::ReactivationsController do
  context "#create" do
    it "calls #fulfill on a `Reactivation` and it works" do
      fake_subscription = double
      fake_reactivation = double(fulfill: true)
      user = create(:user)
      allow(user).to receive(:subscription).and_return(fake_subscription)
      allow(Reactivation).
        to receive(:new).
        with(subscription: fake_subscription).
        and_return(fake_reactivation)
      sign_in_as user

      post :create

      expect(flash[:notice]).to eq t("subscriptions.flashes.reactivate.success")
      expect(response).to redirect_to(my_account_path)
    end

    it "calls #fulfill on a `Reactivation` and it does not work" do
      fake_subscription = double
      fake_reactivation = double(fulfill: false)
      user = create(:user)
      allow(user).to receive(:subscription).and_return(fake_subscription)
      allow(Reactivation).
        to receive(:new).
        with(subscription: fake_subscription).
        and_return(fake_reactivation)
      sign_in_as user

      post :create

      expect(flash[:error]).to eq t("subscriptions.flashes.reactivate.failure")
      expect(response).to redirect_to(my_account_path)
    end
  end

  def t(key)
    I18n.t(key)
  end
end
