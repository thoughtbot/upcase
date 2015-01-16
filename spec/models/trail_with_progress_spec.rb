require "rails_helper"

describe TrailWithProgress do
  it "decorates its component" do
    user = stub("user")
    trail = build_stubbed(:trail)
    trail_with_progress = TrailWithProgress.new(trail, user: user)

    expect(trail_with_progress).to be_a(SimpleDelegator)
    expect(trail_with_progress.name).to eq(trail.name)
  end

  describe "state" do
    context "before starting any exercise" do
      it "is unstarted" do
        trail = create_trail_with_progress(nil, nil)

        expect(trail).to be_unstarted
        expect(trail).not_to be_in_progress
        expect(trail).not_to be_complete
        expect(trail).not_to be_just_finished
      end
    end

    context "after starting an exercise" do
      it "is in progress" do
        trail = create_trail_with_progress(Status::IN_PROGRESS, nil)

        expect(trail).not_to be_unstarted
        expect(trail).to be_in_progress
        expect(trail).not_to be_complete
        expect(trail).not_to be_just_finished
      end
    end

    context "after completing all exercises recently" do
      it "has been completed, and is just finished" do
        trail = create_trail_with_progress(Status::COMPLETE, Status::COMPLETE)

        expect(trail).not_to be_unstarted
        expect(trail).not_to be_in_progress
        expect(trail).to be_complete
        expect(trail).to be_just_finished
      end
    end

    context "after completing all exercises in the past" do
      it "has been completed, and is complete" do
        trail = create(:trail)
        user = create(:user)
        create(
          :status,
          completeable: trail,
          user: user,
          state: Status::COMPLETE,
          created_at: 1.week.ago
        )
        trail = TrailWithProgress.new(trail, user: user)

        expect(trail).not_to be_unstarted
        expect(trail).not_to be_in_progress
        expect(trail).to be_complete
        expect(trail).not_to be_just_finished
      end
    end
  end

  describe "#update_status" do
    it "sets completed if all exercises are completed" do
      trail = create_trail_with_progress(Status::COMPLETE, Status::COMPLETE)

      result = trail.update_status.state

      expect(result).to eq(Status::COMPLETE)
    end

    it "sets in progress if any exercise is in progress" do
      trail = create_trail_with_progress(Status::IN_PROGRESS, nil)

      result = trail.update_status.state

      expect(result).to eq(Status::IN_PROGRESS)
    end

    it "sets in progress if all exercises are completed or unstarted" do
      trail = create_trail_with_progress(Status::COMPLETE, nil)

      result = trail.update_status.state

      expect(result).to eq(Status::IN_PROGRESS)
    end
  end

  describe "#completeables" do
    context "with no in-progress exercises" do
      it "marks the first unstarted exercise as next up" do
        trail = create_trail_with_progress(Status::COMPLETE, nil, nil)

        result = trail.completeables.to_a

        expect(result.map(&:state)).to match_array([
          Status::COMPLETE,
          Status::NEXT_UP,
          Status::UNSTARTED
        ])
      end
    end

    context "with an in-progress exercise" do
      it "doesn't mark any exercises as next up" do
        trail = create_trail_with_progress(Status::IN_PROGRESS, nil, nil)

        result = trail.completeables.to_a

        expect(result.map(&:state)).to match_array([
          Status::IN_PROGRESS,
          Status::UNSTARTED,
          Status::UNSTARTED
        ])
      end
    end

    describe "#can_be_accessed?" do
      it "can access if its state is Next Up, or already had access" do
        trail = create_trail_with_progress(Status::COMPLETE, nil, nil, nil)

        result = trail.completeables.to_a

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
    trail.update_state_for(user)
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
