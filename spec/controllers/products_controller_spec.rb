require 'spec_helper'

describe ProductsController do
  context "show" do
    it "render the show licensed page if the user has one" do
      user = create(:user)
      license = create(:license, user: user)
      sign_in_as user

      get :show, id: license.licenseable

      expect(response).to render_template "show_licensed"
    end

    it "renders the show page if a user has not purchased" do
      user = create(:user)
      license = create(:license)
      sign_in_as user

      get :show, id: license.licenseable

      expect(response).to render_template "show"
    end
  end
end
