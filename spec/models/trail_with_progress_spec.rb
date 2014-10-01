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
      it "marks the first unstarted exercise as active" do
        trail = create(:trail)
        first = create(:exercise)
        second = create(:exercise)
        third = create(:exercise)
        trail.add_exercise first
        trail.add_exercise second
        trail.add_exercise third
        user = create(:user)
        first.statuses.create!(user: user, state: Status::REVIEWED)
        trail_with_progress = TrailWithProgress.new(trail, user: user)

        result = trail_with_progress.exercises

        expect(result.first).not_to be_active
        expect(result.second).to be_active
        expect(result.third).not_to be_active
        expect(result.first.title).to eq(first.title)
      end
    end

    context "with an in-progress exercise" do
      it "doesn't mark any exercises as active" do
        trail = create(:trail)
        first = create(:exercise)
        second = create(:exercise)
        third = create(:exercise)
        trail.add_exercise first
        trail.add_exercise second
        trail.add_exercise third
        user = create(:user)
        first.statuses.create!(user: user, state: Status::STARTED)
        trail_with_progress = TrailWithProgress.new(trail, user: user)

        result = trail_with_progress.exercises

        expect(result.first).not_to be_active
        expect(result.second).not_to be_active
        expect(result.third).not_to be_active
      end
    end
  end
end
