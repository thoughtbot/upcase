require "rails_helper"

describe "explore/_topic.html" do
  context "with less than 4 resources" do
    it "doesn't show View All card" do
      exercise = ExerciseWithProgress.new(
        build_stubbed(:exercise),
        "Not Started"
      )
      topic_with_resources = stub(
        "topic_with_resources",
        name: "Topic",
        featured_resources: [exercise, exercise, exercise],
        count: 3
      )
      view_stubs(:current_user).returns(build_stubbed(:user))

      render "explore/topic", topic: topic_with_resources

      expect(rendered).not_to have_content("View All")
    end
  end
end
