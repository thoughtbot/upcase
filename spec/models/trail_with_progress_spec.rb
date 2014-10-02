require "rails_helper"

describe TrailWithProgress do
  it "decorates its component" do
    user = stub("user")
    trail = build_stubbed(:trail)
    trail_with_progress = TrailWithProgress.new(trail, user: user)

    expect(trail_with_progress).to be_a(SimpleDelegator)
    expect(trail_with_progress.name).to eq(trail.name)
  end

  describe "#exercises" do
    context "with no in-progress exercises" do
      it "marks the first unstarted exercise as next up" do
        exercises = create_list(:exercise, 3)
        trail = create(:trail, exercises: exercises)
        user = create(:user)
        exercises.first.statuses.create!(user: user, state: Status::REVIEWED)
        trail_with_progress = TrailWithProgress.new(trail, user: user)

        result = trail_with_progress.exercises

        expect(result.first.state).to eq(Status::REVIEWED)
        expect(result.second.state).to eq(Status::NEXT_UP)
        expect(result.third.state).to eq(Status::NOT_STARTED)
        expect(result.first.title).to eq(exercises.first.title)
      end
    end

    context "with an in-progress exercise" do
      it "doesn't mark any exercises as next up" do
        exercises = create_list(:exercise, 3)
        trail = create(:trail, exercises: exercises)
        user = create(:user)
        exercises.first.statuses.create!(user: user, state: Status::STARTED)
        trail_with_progress = TrailWithProgress.new(trail, user: user)

        result = trail_with_progress.exercises

        expect(result.first.state).to eq(Status::STARTED)
        expect(result.second.state).to eq(Status::NOT_STARTED)
        expect(result.third.state).to eq(Status::NOT_STARTED)
      end
    end
  end
end
