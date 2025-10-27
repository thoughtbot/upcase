require "rails_helper"

RSpec.describe CompletedTrailsController do
  it "shows completed trails for current user" do
    completed_trails = double("completed-trails")
    expect(Trail).to receive(:completed_for).and_return(completed_trails)

    get :index

    expect(assigns(:trails)).to eq(completed_trails)
    expect(response).to be_successful
  end
end
