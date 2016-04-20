require "rails_helper"

describe "User_signup redirect" do
  it "redirects to join path" do
    get "/upcase/sign_up"

    expect(response).to redirect_to join_path
  end
end
