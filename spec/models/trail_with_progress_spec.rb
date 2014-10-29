require "rails_helper"

describe TrailWithProgress do
  it "decorates its component" do
    user = stub("user")
    trail = build_stubbed(:trail)
    trail_with_progress = TrailWithProgress.new(trail, user: user)

    expect(trail_with_progress).to be_a(SimpleDelegator)
    expect(trail_with_progress.name).to eq(trail.name)
  end

  describe "#unstarted?" do
    context "before starting any exercise" do
      it "returns false" do
        trail = create_trail_with_progress(nil, nil)

        expect(trail).to be_unstarted
      end
    end

    context "after starting an exercise" do
      it "returns true" do
        trail = create_trail_with_progress(Status::IN_PROGRESS, nil)

        expect(trail).not_to be_unstarted
      end
    end
  end

  describe "#complete?" do
    context "before receving a review on each exercise" do
      it "returns false" do
        trail = create_trail_with_progress(Status::COMPLETE, Status::COMPLETE)

        expect(trail).to be_complete
      end
    end

    context "after receving a review on each exercise" do
      it "returns true" do
        trail = create_trail_with_progress(
          Status::COMPLETE,
          Status::IN_PROGRESS
        )

        expect(trail).not_to be_complete
      end
    end
  end

  describe "#exercises" do
    describe "#can_be_accessed?" do
      it "can access if its state is complete, or already had access" do
        trail = create_trail_with_progress(Status::COMPLETE, nil, nil, nil)

        result = trail.exercises.to_a

        expect(result.map(&:can_be_accessed?)).
          to match_array([true, true, false, false])
      end
    end
  end

  def create_trail_with_progress(*states)
    user = create(:user)
    exercises =
      states.map { |state| create_exercise_with_state(state, user: user) }
    trail = create(:trail, exercises: exercises)
    TrailWithProgress.new(trail, user: user)
  end

  def create_exercise_with_state(state, user:)
    create(:exercise).tap do |exercise|
      if state.present?
        exercise.statuses.create!(user: user, state: state)
      end
    end
  end
end
