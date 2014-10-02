require "rails_helper"

describe Trail do
  it { should validate_presence_of(:name) }

  it { should have_many(:steps).dependent(:destroy) }
  it { should have_many(:exercises).through(:steps) }

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
      exercises = create_list(:exercise, 3)
      trail = create(:trail, exercises: exercises)
      exercises.first.statuses.create!(user: user, state: Status::REVIEWED)
      exercises.second.statuses.create!(user: user, state: Status::SUBMITTED)
      exercises.first.statuses.create!(
        user: other_user,
        state: Status::REVIEWED
      )

      result = trail.steps_remaining_for(user)

      expect(result).to eq(2)
    end

    it "returns the total number of steps for a user who hasn't started" do
      user = create(:user)
      exercises = create_list(:exercise, 2)
      trail = create(:trail, exercises: exercises)

      result = trail.steps_remaining_for(user)

      expect(result).to eq(2)
    end
  end
end
