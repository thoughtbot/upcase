require "rails_helper"

describe Subscriber::ReactivationsController do
  context "#create" do
    it "calls #fulfill on a `Reactivation` and it works" do
      user = create_user_stubbing_subscription(double)
      reactivating_subscription(works: true, subscription: user.subscription)
      sign_in_as user

      post :create

      expect(flash[:notice]).to eq t("subscriptions.flashes.reactivate.success")
      expect(response).to redirect_to(my_account_path)
    end

    it "calls #fulfill on a `Reactivation` and it does not work" do
      user = create_user_stubbing_subscription(double)
      reactivating_subscription(works: false, subscription: user.subscription)
      sign_in_as user

      post :create

      expect(flash[:error]).to eq t("subscriptions.flashes.reactivate.failure")
      expect(response).to redirect_to(my_account_path)
    end
  end

  def create_user_stubbing_subscription(subscription)
    user = create(:user)
    allow(user).to receive(:subscription).and_return(subscription)
    user
  end

  def reactivating_subscription(works:, subscription:)
    allow(Reactivation).
      to receive(:new).
      with(subscription: subscription).
      and_return(double("Reactivation", fulfill: works))
  end

  def t(key)
    I18n.t(key)
  end
end
