require "rails_helper"

describe ShowsController do
  context "show" do
    it "doesn't render other formats" do
      show = create(:show)

      expect do
        get :show, params: { id: show }, format: :json
      end.to raise_exception(ActionController::UnknownFormat)
    end
  end
end
