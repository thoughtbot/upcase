require "rails_helper"

describe "trails/_exercise.html" do
  it "renders a class that matches the status" do
    user = stub_user
    exercise = stub_exercise
    status = stub("status", state: "Not Started")
    exercise.stubs(:status_for).with(user).returns(status)

    render "trails/exercise", exercise: exercise

    expect(rendered).to have_css(".not-started")
  end

  context "with an active exercise" do
    it "renders an active class" do
      stub_user
      exercise = stub_exercise(active: true)

      render "trails/exercise", exercise: exercise

      expect(rendered).to have_css(".active")
    end
  end

  context "with an inactive exercise" do
    it "doesn't render an active class" do
      stub_user
      exercise = stub_exercise(active: false)

      render "trails/exercise", exercise: exercise

      expect(rendered).not_to have_css(".active")
    end
  end

  def stub_user
    build_stubbed(:user).tap do |user|
      user.stubs(:has_access_to?).returns(true)
      view_stubs(:current_user).returns(user)
    end
  end

  def stub_exercise(active: false)
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      build_stubbed(:exercise). tap do |exercise|
        exercise.stubs(:active?).returns(active)
      end
    end
  end
end
