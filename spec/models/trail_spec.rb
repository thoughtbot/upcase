require "rails_helper"

describe Trail do
  it { should validate_presence_of(:name) }

  it { should have_many(:steps).dependent(:destroy) }
  it { should have_many(:exercises).through(:steps) }

  describe "#add_exercise" do
    it "associates withs the trail in order" do
      trail = create(:trail)

      trail.add_exercise create(:exercise, title: "one")
      trail.add_exercise create(:exercise, title: "two")

      expect(trail.exercises.ordered.map(&:title)).to eq(%w(one two))
    end
  end

  describe ".most_recent" do
    it "returns more recent trails first" do
      create :trail, created_at: 2.day.ago, name: "two"
      create :trail, created_at: 1.days.ago, name: "one"
      create :trail, created_at: 3.days.ago, name: "three"

      result = Trail.most_recent

      expect(result.map(&:name)).to eq(%w(one two three))
    end
  end

  describe "#steps_remaining_for" do
    it "returns the number of exercises the user hasn't completed" do
      user = create(:user)
      other_user = create(:user)
      trail = create(:trail)
      first = create(:exercise)
      second = create(:exercise)
      third = create(:exercise)
      trail.add_exercise(first)
      trail.add_exercise(second)
      trail.add_exercise(third)
      first.statuses.create!(user: user, state: "Reviewed")
      second.statuses.create!(user: user, state: "Submitted")
      first.statuses.create!(user: other_user, state: "Reviewed")

      result = trail.steps_remaining_for(user)

      expect(result).to eq(2)
    end

    it "returns the total number of steps for a user who hasn't started" do
      user = create(:user)
      trail = create(:trail)
      first = create(:exercise)
      second = create(:exercise)
      trail.add_exercise(first)
      trail.add_exercise(second)

      result = trail.steps_remaining_for(user)

      expect(result).to eq(2)
    end
  end
end
