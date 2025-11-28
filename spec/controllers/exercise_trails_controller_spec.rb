require "rails_helper"

RSpec.describe ExerciseTrailsController do
  include StubCurrentUserHelper

  describe "#show" do
    context "with a recognized exercise" do
      it "should redirect to trail page" do
        trail = create(:trail)
        exercise = create(:exercise)
        trail.exercises << exercise

        get :show, params: {exercise_id: exercise.uuid}

        expect(response).to redirect_to(trail)
      end
    end

    context "with an unrecognized exercise" do
      it "returns a 404" do
        expect { get :show, params: {exercise_id: "not-a-real-id"} }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with an exercise not associated to a trail" do
      it "redirects to the root with a notice" do
        exercise = create(:exercise)

        get :show, params: {exercise_id: exercise.uuid}

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(no_trail_notice)
      end
    end

    def no_trail_notice
      I18n.t("exercise_trails.show.no_trail")
    end
  end
end
