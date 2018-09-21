require "rails_helper"

describe SearchesController do
  describe "#show" do
    context "with no query" do
      it "should not fire an analytics event" do
        get :show

        expect(analytics).not_to have_tracked("Searched")
      end
    end
  end
end
