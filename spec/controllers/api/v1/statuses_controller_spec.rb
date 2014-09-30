require "rails_helper"

describe Api::V1::StatusesController do
  it 'returns a 401 when users are not authenticated' do
    post :create, exercise_uuid: create(:exercise).uuid

    expect(response.code).to eq "401"
  end

  context "#update" do
    it "updates the status of the given exercise for the authenticated user" do
      exercise = create(:exercise)
      user = create(:user)
      controller.stubs(:doorkeeper_token).returns(stub(accessible?: true))
      controller.stubs(:resource_owner).returns(user)

      post :create, exercise_uuid: exercise.uuid, state: "Submitted"

      expect(response).to be_success
      expect(exercise.status_for(user).state).to eq "Submitted"
    end
  end
end
