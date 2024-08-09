require "rails_helper"

describe CompleteableWithProgressQuery do
  describe "#each" do
    it "decorates completeables with progress" do
      exercise_step_1 = create(:exercise)
      video_step_2 = create(:video)
      exercise_step_3 = create(:exercise)
      user = create(:user)
      status_finder = StatusFinder.new(user: user)
      completeables = [exercise_step_1, video_step_2, exercise_step_3]
      query = CompleteableWithProgressQuery
        .new(status_finder: status_finder, completeables: completeables)

      completeables_query = query.to_a

      expect(completeables_query[0].name).to eq(exercise_step_1.name)
      expect(completeables_query[1].name).to eq(video_step_2.name)
      expect(completeables_query[0].state).to eq(Status::NEXT_UP)
      expect(completeables_query[1].state).to eq(Status::UNSTARTED)
      expect(completeables_query[2].state).to eq(Status::UNSTARTED)
    end

    it "properly wraps both exercises and videos" do
      user = create(:user)
      status_finder = StatusFinder.new(user: user)
      exercise = create(:exercise)
      video = create(:video)
      create(
        :status,
        completeable: exercise,
        user: user,
        state: Status::IN_PROGRESS
      )
      create(:status, completeable: video, user: user, state: Status::COMPLETE)
      completeables = [exercise, video]

      query = CompleteableWithProgressQuery
        .new(status_finder: status_finder, completeables: completeables).to_a

      expect(query[0].state).to eq(Status::IN_PROGRESS)
      expect(query[1].state).to eq(Status::COMPLETE)
    end
  end

  describe "#includes" do
    it "calls includes in underlying completeables array" do
      user = User.new
      status_finder = StatusFinder.new(user: user)
      completeables = double("completeables", includes: nil)
      query = CompleteableWithProgressQuery
        .new(status_finder: status_finder, completeables: completeables)

      query.includes(:args)

      expect(completeables).to have_received(:includes).with(:args)
    end
  end
end
