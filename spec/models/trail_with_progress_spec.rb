require "rails_helper"

describe TrailWithProgress do
  it "decorates its component" do
    user = double("user")
    trail = build_stubbed(:trail)
    trail_with_progress = TrailWithProgress.new(
      trail,
      user: user,
      status_finder: double(StatusFinder),
    )

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
        trail = TrailWithProgress.new(
          trail,
          user: user,
          status_finder: StatusFinder.new(user: user),
        )

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
  end

  describe "#started_on" do
    it "returns date of status" do
      trail = create_trail_with_progress
      expect(trail.statuses.size).to eq(1)

      result = trail.started_on
      expect(result).to eq(trail.statuses.last.created_at.to_date)
    end

    it "returns tomorrow with no statuses" do
      trail = create_trail_with_progress
      trail.statuses.destroy_all
      expect(trail.reload.statuses.size).to eq(0)

      result = trail.started_on
      expect(result).to eq(Date.tomorrow)
    end
  end

  describe "#steps_remaining" do
    it "delegates to the trail" do
      trail = create_trail_with_progress(
        Status::COMPLETE,
        Status::IN_PROGRESS,
        nil,
        nil
      )

      result = trail.steps_remaining

      expect(result).to eq(3)
    end
  end

  describe "#steps_remaining" do
    it "returns the number of exercises the user hasn't completed" do
      user = create(:user)
      other_user = create(:user)
      exercises = create_list(:exercise, 3)
      videos = create_list(:video, 2)
      trail = create(:trail, exercises: exercises, videos: videos)
      exercises.first.statuses.create!(user: user, state: Status::COMPLETE)
      exercises.second.statuses.create!(user: user, state: Status::IN_PROGRESS)
      exercises.first.statuses.create!(
        user: other_user,
        state: Status::COMPLETE,
      )
      videos.first.statuses.create!(user: user, state: Status::COMPLETE)
      videos.second.statuses.create!(user: user, state: Status::IN_PROGRESS)
      videos.second.statuses.create!(user: other_user, state: Status::COMPLETE)

      result = steps_remaining_for(trail, user)

      expect(result).to eq(3)
    end

    it "returns the total number of steps for a user who hasn't started" do
      user = create(:user)
      exercises = create_list(:exercise, 2)
      trail = create(:trail, exercises: exercises)

      result = steps_remaining_for(trail, user)

      expect(result).to eq(2)
    end

    def steps_remaining_for(trail, user)
      TrailWithProgress.new(
        trail,
        user: user,
        status_finder: StatusFinder.new(user: user),
      ).steps_remaining
    end
  end

  def create_trail_with_progress(*states)
    user = create(:user)
    exercises =
      states.map { |state| create_exercise_with_state(state, user: user) }
    trail = create(:trail, exercises: exercises)
    trail.update_state_for(user)
    TrailWithProgress.new(
      trail,
      user: user,
      status_finder: StatusFinder.new(user: user),
    )
  end

  def create_exercise_with_state(state, user:)
    create(:exercise).tap do |exercise|
      if state.present?
        exercise.statuses.create!(user: user, state: state)
      end
    end
  end
end
