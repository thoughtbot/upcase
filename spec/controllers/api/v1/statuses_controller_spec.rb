require "rails_helper"

describe Api::V1::StatusesController do
  describe "#create" do
    it "returns a 401 when users are not authenticated" do
      post :create, params: { exercise_uuid: "exercise-uuid" }

      expect(response.code).to eq "401"
    end

    it "returns a 404 when exercise doesn't exist" do
      stub_oauth_authenticated_user

      expect do
        post :create, params: { exercise_uuid: "exercise-uuid" }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    context "with existing exercise and authenticated user" do
      it "updates the status of the given exercise" do
        stub_oauth_authenticated_user
        exercise = stub_exercise
        updater = stub_updater

        post :create, params: {
          exercise_uuid: exercise.uuid,
          state: Status::COMPLETE,
        }

        expect(response.code).to eq "200"
        expect(StatusUpdater).to have_received(:new)
        expect(updater).to have_received(:update_state).with(Status::COMPLETE)
      end
    end
  end

  def stub_exercise
    exercise = build_stubbed(:exercise)
    allow(exercise).to receive(:trail).and_return(build_stubbed(:trail))
    allow(Exercise).to receive(:find_by!).and_return(exercise)
    exercise
  end

  def stub_updater
    spy("status_updater").tap do |updater|
      allow(updater).to receive(:update_state)
      allow(StatusUpdater).to receive(:new).and_return(updater)
    end
  end
end
