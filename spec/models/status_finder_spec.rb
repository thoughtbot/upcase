require "rails_helper"

describe StatusFinder do
  describe "#current_status_for" do
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

        result = status_finder.current_status_for(exercise)

        expect(result.state).to eq(Status::COMPLETE)
      end
    end

    context "with no status recorded" do
      it "returns unstarted" do
        user = create(:user)
        exercise = create(:exercise)
        status_finder = StatusFinder.new(user: user)

        result = status_finder.current_status_for(exercise)

        expect(result.state).to eq(Status::UNSTARTED)
      end
    end

    context "without a user" do
      it "returns unstarted" do
        exercise = create(:exercise)
        status_finder = StatusFinder.new(user: Guest.new)

        result = status_finder.current_status_for(exercise)

        expect(result.state).to eq(Status::UNSTARTED)
      end
    end
  end

  describe "#earliest_status_for" do
    context "with a status in the database" do
      it "returns the oldest status date for the completeable" do
        user = create(:user)
        trail = create(:trail)
        dates = [1.month.ago, Date.current, 2.weeks.ago]
        statuses = create_statuses_for_dates(user, trail, dates)
        status_finder = StatusFinder.new(user: user)

        status = status_finder.earliest_status_for(trail)

        expect(status).to eq(statuses.first)
      end
    end

    context "with no status recorded" do
      it "returns Unstarted" do
        trail = create(:trail)
        status_finder = StatusFinder.new(user: Guest.new)

        result = status_finder.earliest_status_for(trail)

        expect(result.state).to eq(Status::UNSTARTED)
      end
    end
  end

  def create_status(user, exercise, state, created_at: Time.current)
    create(
      :status,
      user: user,
      completeable: exercise,
      state: state,
      created_at: created_at
    )
  end

  def create_statuses_for_dates(user, trail, dates)
    dates.map do |date|
      create_status(user, trail, Status::IN_PROGRESS, created_at: date)
    end
  end
end
