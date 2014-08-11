require "rails_helper"

describe ShowsController do
  context "show" do
    it "render the show licensed page if the user has one" do
      user = create(:user)
      show = create(:show)
      create(:license, user: user, licenseable: show)
      sign_in_as user

      get :show, id: show

      expect(response).to render_template(
        "layouts/application",
        "show_licensed"
      )
    end

    it "renders the show page if a user has not purchased" do
      user = create(:user)
      show = create(:show)
      sign_in_as user

      get :show, id: show

      expect(response).to render_template(
        "layouts/landing_pages",
        "show"
      )
    end

    it "renders the show page for a visitor" do
      show = create(:show)
      get :show, id: show

      expect(response).to render_template(
        "layouts/landing_pages",
        "show"
      )
    end
  end
end
