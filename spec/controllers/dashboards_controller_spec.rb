require "rails_helper"

describe DashboardsController do
  it "sorts topics by number of resources" do
    sign_in
    topics = [stub(count: 1), stub(count: 2)]
    TopicsWithResources.stubs(:new).returns(topics)

    get :show

    expect(assigns(:topics)).to eq(topics.reverse)
  end
end
