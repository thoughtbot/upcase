require "rails_helper"

describe TrailWithProgress do
  it "decorates its component" do
    user = stub("user")
    trail = build_stubbed(:trail)
    trail_with_progress = TrailWithProgress.new(trail, user: user)

    expect(trail_with_progress).to be_a(SimpleDelegator)
    expect(trail_with_progress.name).to eq(trail.name)
  end

  describe "#complete?" do
    context "before receving a review on each exercise" do
      it "returns false" do
        trail = create_trail_with_progress(Status::REVIEWED, Status::REVIEWED)

        expect(trail).to be_complete
      end
    end

    context "after receving a review on each exercise" do
      it "returns true" do
        trail = create_trail_with_progress(Status::REVIEWED, Status::SUBMITTED)

        expect(trail).not_to be_complete
      end
    end
  end

  describe "#exercises" do
    context "with no in-progress exercises" do
      it "marks the first unstarted exercise as next up" do
        trail = create_trail_with_progress(Status::REVIEWED, nil, nil)

        result = trail.exercises

        expect(result.first.state).to eq(Status::REVIEWED)
        expect(result.second.state).to eq(Status::NEXT_UP)
        expect(result.third.state).to eq(Status::NOT_STARTED)
      end
    end

    context "with an in-progress exercise" do
      it "doesn't mark any exercises as next up" do
        trail = create_trail_with_progress(Status::STARTED, nil, nil)

        result = trail.exercises

        expect(result.first.state).to eq(Status::STARTED)
        expect(result.second.state).to eq(Status::NOT_STARTED)
        expect(result.third.state).to eq(Status::NOT_STARTED)
      end
    end

    describe "#can_be_accessed?" do
      it "can access if its state is Next Up, or already had access" do
        trail = create_trail_with_progress(Status::REVIEWED, nil, nil, nil)

        result = trail.exercises

        expect(result.first.can_be_accessed?).to be_truthy
        expect(result.second.can_be_accessed?).to be_truthy
        expect(result.third.can_be_accessed?).to be_falsy
        expect(result.fourth.can_be_accessed?).to be_falsy
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
