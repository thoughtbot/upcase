require "rails_helper"

describe Exercise do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should have_many(:classifications) }

  describe ".ordered" do
    it "returns older exercises first" do
      create(:exercise, title: "first", created_at: 3.days.ago)
      create(:exercise, title: "third", created_at: 1.day.ago)
      create(:exercise, title: "second", created_at: 2.days.ago)

      expect(Exercise.ordered.pluck(:title)).to eq(%w(first second third))
    end
  end

  describe "#status_for" do
    it "returns null object if no related status" do
      exercise = Exercise.new
      user = User.new

      expect(exercise.status_for(user)).to be_a NotStarted
    end

    it "returns the latest status for the user" do
      exercise = create(:exercise)
      user = create(:user)
      status = create(:status, exercise: exercise, user: user)
      Timecop.travel(1.day.ago) do
        create(:status, exercise: exercise, user: user)
      end

      expect(exercise.status_for(user)).to eq status
    end
  end
end
