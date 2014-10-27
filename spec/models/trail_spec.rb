require "rails_helper"

describe Trail do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  it { should have_many(:steps).dependent(:destroy) }
  it { should have_many(:exercises).through(:steps) }

  describe ".most_recent_published" do
    it "returns more recent trails first" do
      create :trail, published: true, created_at: 2.day.ago, name: "two"
      create :trail, published: true, created_at: 1.days.ago, name: "one"
      create :trail, published: true, created_at: 3.days.ago, name: "three"

      result = Trail.most_recent_published

      expect(result.map(&:name)).to eq(%w(one two three))
    end

    it "only returns published trails" do
      create :trail, published: true, name: "two"
      create :trail, published: true, name: "one"
      create :trail, published: false, name: "unpublished"

      result = Trail.most_recent_published

      expect(result.map(&:name)).to match_array(%w(one two))
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

  describe "#find" do
    it "finds its to_param value" do
      trail = create(:trail)

      result = Trail.find(trail.to_param)

      expect(result).to eq(trail)
    end
  end

  describe "#to_param" do
    it "returns a value based on its name" do
      trail = create(:trail, name: "Example Trail")

      result = trail.to_param

      expect(result).to eq("example-trail")
    end
  end

  describe "#exercises" do
    it "should be in order of the step position" do
      trail = create(:trail)
      second_step = create(:step, trail: trail, position: 2)
      first_step = create(:step, trail: trail, position: 1)

      expect(trail.exercises).to eq [first_step.exercise, second_step.exercise]
    end
  end

  describe "#exercise_ids=" do
    it "should preserve ordering" do
      exercises = create_list(:exercise, 3)

      trail = create(
        :trail,
        exercise_ids: [exercises[2], exercises[1], exercises[0]].map(&:id)
      )

      expect(trail.exercises(true).map(&:id)).to eq(
        [exercises[2], exercises[1], exercises[0]].map(&:id)
      )

      trail.exercise_ids = [exercises[0], exercises[2], exercises[1]].map(&:id)
      trail.save!

      expect(trail.exercises(true).map(&:id)).to eq(
        [exercises[0], exercises[2], exercises[1]].map(&:id)
      )
    end
  end
end
