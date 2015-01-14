require "rails_helper"

describe ShowsController do
  context "show" do
    it "renders show_subscribed page if user is subscribed" do
      user = create(:subscriber)
      show = create(:show)
      sign_in_as user

      get :show, id: show

      expect(response).to render_template(
        "layouts/application",
        "show_subscribed"
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

    it "doesn't render other formats" do
      show = create(:show)

      expect do
        get :show, id: show, format: :json
      end.to raise_exception(ActionController::UnknownFormat)
    end
  end
end
