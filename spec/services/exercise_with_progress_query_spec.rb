require "rails_helper"

describe ExerciseWithProgressQuery do
  describe "#each" do
    it "decorates an exercise with progress" do
      create(:exercise)
      exercise = create(:exercise)
      user = create(:user)
      create(:status, exercise: exercise, user: user, state: "Pushed")
      query = ExerciseWithProgressQuery.new(user: user, exercises: Exercise.all)

      exercises_array = query.to_a

      expect(exercises_array.last.title).to eq(exercise.title)
      expect(exercises_array.last.state).to eq("Pushed")
    end
  end

  describe "#includes" do
    it "calls includes in underlying exercises array" do
      user = User.new
      exercises = stub("exercises", includes: nil)
      query = ExerciseWithProgressQuery.new(user: user, exercises: exercises)

      query.includes(:args)

      expect(exercises).to have_received(:includes).with(:args)
    end
  end

  describe "#status_for" do
    it "returns null object if no related status" do
      user = User.new
      query = ExerciseWithProgressQuery.new(user: user, exercises: Exercise.all)

      expect(query.status_for(user)).to be_a NotStarted
    end

    it "returns the latest status for the user" do
      exercise = create(:exercise)
      user = create(:user)
      status = create(:status, exercise: exercise, user: user)
      Timecop.travel(1.day.ago) do
        create(:status, exercise: exercise, user: user)
      end
      query = ExerciseWithProgressQuery.new(user: user, exercises: Exercise.all)

      expect(query.status_for(exercise.id)).to eq status
    end
  end
end
