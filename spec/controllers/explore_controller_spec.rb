require "rails_helper"

describe ExploreController do
  it "sorts topics by number of resources" do
    sign_in
    topics = [stub(count: 1), stub(count: 2)]
    TopicsWithResources.stubs(:new).returns(topics)

    get :show

    result = assigns(:explore).topics
    expect(result).to eq(topics.reverse)
  end
end
