require "rails_helper"

describe ExploreController do
  describe "#show" do
    context "signed in" do
      it "sorts topics by number of resources" do
        sign_in
        topics = [stub(count: 1), stub(count: 2)]
        TopicsWithResources.stubs(:new).returns(topics)

        get :show

        result = assigns(:explore).topics
        expect(result).to eq(topics.reverse)
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
