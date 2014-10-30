require "rails_helper"

describe ExerciseWithProgressQuery do
  describe "#each" do
    it "decorates exercises with progress" do
      exercise = create(:exercise)
      create(:exercise)
      user = create(:user)
      query = ExerciseWithProgressQuery.new(user: user, exercises: Exercise.all)

      exercises = query.to_a

      expect(exercises[0].title).to eq(exercise.title)
      expect(exercises[0].state).to eq(Status::NEXT_UP)
      expect(exercises[1].state).to eq(Status::UNSTARTED)
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

      expect(query.status_for(user)).to be_a Unstarted
    end

    it "returns the latest status for the user" do
      exercise = create(:exercise)
      user = create(:user)
      status = create(:status, completeable: exercise, user: user)
      Timecop.travel(1.day.ago) do
        create(:status, completeable: exercise, user: user)
      end
      query = ExerciseWithProgressQuery.new(user: user, exercises: Exercise.all)

      expect(query.status_for(exercise.id)).to eq status
    end
  end
end
