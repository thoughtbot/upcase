require "rails_helper"

describe Trail do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:topic) }

  it { should belong_to(:topic) }
  it { should have_many(:repositories).dependent(:destroy) }
  it { should have_many(:statuses).dependent(:destroy) }
  it { should have_many(:steps).dependent(:destroy) }
  it { should have_many(:exercises).through(:steps) }
  it { should have_many(:videos).through(:steps) }

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

  context "self.published" do
    it "returns published trails" do
      _unpublished = create(:trail, published: false)
      published = create(:trail, published: true)

      expect(Trail.published).to eq([published])
    end
  end

  describe ".by_topic" do
    it "returns trails sorted by their topic's name" do
      create(:trail, topic: create(:topic, name: "A"))
      create(:trail, topic: create(:topic, name: "C"))
      create(:trail, topic: create(:topic, name: "B"))

      result = Trail.by_topic.map(&:topic_name)

      expect(result).to eq %w(A B C)
    end
  end

  describe ".completed_for" do
    it "shows completed trails for a user" do
      _incomplete = create(:trail)
      completed = create(:trail)
      user = create(:user)
      create(
        :status,
        completeable: completed,
        user: user,
        state: Status::COMPLETE
      )

      result = Trail.completed_for(user)

      expect(result.map(&:id)).to match_array([completed.id])
    end
  end

  describe ".accessible_without_subscription?" do
    it "returns false" do
      result = Trail.accessible_without_subscription?

      expect(result).to be false
    end
  end

  describe "#steps_remaining_for" do
    it "returns the number of exercises the user hasn't completed" do
      user = create(:user)
      other_user = create(:user)
      exercises = create_list(:exercise, 3)
      videos = create_list(:video, 2)
      trail = create(:trail, exercises: exercises, videos: videos)
      exercises.first.statuses.create!(user: user, state: Status::COMPLETE)
      exercises.second.statuses.create!(user: user, state: Status::IN_PROGRESS)
      exercises.first.statuses.create!(
        user: other_user,
        state: Status::COMPLETE
      )
      videos.first.statuses.create!(user: user, state: Status::COMPLETE)
      videos.second.statuses.create!(user: user, state: Status::IN_PROGRESS)
      videos.second.statuses.create!(user: other_user, state: Status::COMPLETE)

      result = trail.steps_remaining_for(user)

      expect(result).to eq(3)
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

  describe "#update_state_for" do
    it "updates the status of an unstarted trail" do
      user = create(:user)
      exercise = create(:exercise)
      trail = create(:trail, exercises: [exercise])

      trail.update_state_for(user)

      trail_status = trail.statuses.where(user: user).most_recent
      expect(trail_status).to be_nil
    end

    it "updates the status of an in-progress trail" do
      user = create(:user)
      exercise = create(:exercise)
      create(
        :status,
        completeable: exercise,
        user: user,
        state: Status::IN_PROGRESS
      )
      trail = create(:trail, exercises: [exercise])

      trail.update_state_for(user)

      trail_state = trail.statuses.where(user: user).most_recent.state
      expect(trail_state).to eq Status::IN_PROGRESS
    end

    it "updates the status of a complete trail" do
      user = create(:user)
      trail = trail_with_exercise_states(user, Status::COMPLETE, nil)
      exercise = trail.exercises.last
      create(
        :status,
        completeable: exercise,
        user: user,
        state: Status::COMPLETE
      )

      trail.update_state_for(user)

      trail_state = trail.statuses.where(user: user).most_recent.state
      expect(trail_state).to eq Status::COMPLETE
    end
  end

  describe "#exercises" do
    it "should be in order of the step position" do
      trail = create(:trail)
      second_step = create(:step, trail: trail, position: 2)
      first_step = create(:step, trail: trail, position: 1)

      expect(trail.exercises).
        to eq([first_step.completeable, second_step.completeable])
    end
  end

  describe "#completeables" do
    it "should return all videos and exercises for that trail" do
      trail = create(:trail)
      video = create(:video)
      exercise = create(:exercise)
      create(:step, completeable: video, trail: trail)
      create(:step, completeable: exercise, trail: trail)

      expect(trail.completeables).to eq [video, exercise]
    end
  end

  describe "#step_ids=" do
    it "should preserve ordering" do
      trail = create(:trail)
      steps = create_list(:step, 3, trail: trail)

      expect(trail.steps(true).map(&:id)).to eq(steps.map(&:id))

      trail.step_ids = [steps[0], steps[2], steps[1]].map(&:id)
      trail.save!

      expect(trail.steps(true).map(&:id)).to eq(
        [steps[0], steps[2], steps[1]].map(&:id)
      )
    end
  end

  describe "#teachers" do
    it "returns unique teachers from its video steps" do
      only_first = create(:user, name: "only_first")
      only_second = create(:user, name: "only_second")
      both = create(:user, name: "both")
      trail = create(:trail)
      other_trail_teacher = create(:user, name: "other_trail")
      other_trail = create(:trail)
      create(
        :step,
        trail: trail,
        completeable: create(
          :video,
          teachers: [teacher(both), teacher(only_first)]
        )
      )
      create(
        :step,
        trail: trail,
        completeable: create(
          :video,
          teachers: [teacher(both), teacher(only_second)]
        )
      )
      create(
        :step,
        trail: other_trail,
        completeable: create(
          :video,
          teachers: [teacher(other_trail_teacher)]
        )
      )

      result = trail.teachers

      expect(result.map(&:name)).to match_array(%w(only_first only_second both))
    end

    def teacher(user)
      Teacher.create!(user: user)
    end
  end

  describe "#topic_name" do
    it "delegates to its topic" do
      topic = Topic.new(name: "Ruby")
      trail = Trail.new(topic: topic)

      expect(trail.topic_name).to eq("Ruby")
    end
  end

  describe "#first_completeable" do
    it "returns the completeable associated with the first step in the trail" do
      trail = build_stubbed(:trail)
      create(:step, trail: trail, position: 3)
      create(:step, trail: trail, position: 2)
      step = create(:step, trail: trail, position: 1)

      result = trail.first_completeable

      expect(result).to eq(step.completeable)
    end

    context "when steps are included and there are other ORDER BY clauses" do
      it "still orders by step position" do
        trail = create(:trail)
        create(:step, trail: trail, position: 2)
        step = create(:step, trail: trail, position: 1)

        result = Trail.by_topic.includes(:steps).first.first_completeable

        expect(result).to eq(step.completeable)
      end
    end
  end

  def trail_with_exercise_states(user, *states)
    exercises =
      states.map { |state| create_exercise_with_state(state, user: user) }
    create(:trail, exercises: exercises)
  end

  def create_exercise_with_state(state, user:)
    create(:exercise).tap do |exercise|
      if state.present?
        exercise.statuses.create!(user: user, state: state)
      end
    end
  end
end
