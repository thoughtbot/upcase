require "spec_helper"

describe SubscriptionsController do
  it "redirects to products if the user is logged in" do
    sign_in

    get :new

    expect(response).to redirect_to dashboard_path
  end
end
