require "rails_helper"

describe ExploreController do
  describe "#show" do
    context "signed in" do
      it "sorts topics by number of resources" do
        sign_in
        topics = [double("Topic", count: 1), double("Topic", count: 2)]
        allow(TopicsWithResources).to receive(:new).and_return(topics)

        get :show

        result = assigns(:explore).topics
        expect(result).to eq(topics.reverse)
      end

      it "doesn't recognize other formats" do
        sign_in

        expect do
          get :show, format: :rss
        end.to raise_exception(ActionController::UnknownFormat)
      end
    end

    context "signed out" do
      it "denies access" do
        get :show

        should deny_access
      end
    end
  end
end
