require "rails_helper"

describe HomesController do
  it "renders the landing page if the visitor is not logged in" do
    get :show

    expect(response).
      to render_template("landing_pages/watch-one-do-one-teach-one")
  end

  it "redirects to products if the visitor is logged in" do
    sign_in

    get :show

    expect(response).to redirect_to dashboard_path
  end
end
