require "rails_helper"

describe CompletedTrailsController do
  it "shows completed trails for current user" do
    completed_trails = stub("completed-trails")
    Trail.stubs(:completed_for).returns(completed_trails)

    get :index

    expect(Trail).to have_received(:completed_for)
    expect(assigns(:trails)).to eq(completed_trails)
    expect(response).to be_success
  end
end
