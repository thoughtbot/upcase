require "rails_helper"

describe StatusFinder do
  describe "#status_for" do
    context "with a status in the database" do
      it "returns the state for the given completeable" do
        user = create(:user)
        other_user = create(:user)
        exercise = create(:exercise)
        other_exercise = create(:exercise)
        create_status user, exercise, Status::IN_PROGRESS
        create_status user, exercise, Status::COMPLETE
        create_status user, other_exercise, Status::IN_PROGRESS
        create_status other_user, exercise, Status::IN_PROGRESS
        status_finder = StatusFinder.new(user: user)

        result = status_finder.status_for(exercise)

        expect(result.state).to eq(Status::COMPLETE)
      end
    end

    context "with no status recorded" do
      it "returns unstarted" do
        user = create(:user)
        exercise = create(:exercise)
        status_finder = StatusFinder.new(user: user)

        result = status_finder.status_for(exercise)

        expect(result.state).to eq(Status::UNSTARTED)
      end
    end

    context "without a user" do
      it "returns unstarted" do
        exercise = create(:exercise)
        status_finder = StatusFinder.new(user: nil)

        result = status_finder.status_for(exercise)

        expect(result.state).to eq(Status::UNSTARTED)
      end
    end
  end

  def create_status(user, exercise, state)
    create(:status, user: user, completeable: exercise, state: state)
  end
end
