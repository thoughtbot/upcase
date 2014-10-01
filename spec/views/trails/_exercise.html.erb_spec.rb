require "rails_helper"

describe "trails/_exercise.html" do
  it "renders a class that matches the status" do
    user = build_stubbed(:user)
    user.stubs(:has_access_to?).returns(true)
    view_stubs(:current_user).returns(user)
    exercise = build_stubbed(:exercise)
    status = stub("status", state: "Not Started")
    exercise.stubs(:status_for).with(user).returns(status)

    render "trails/exercise", exercise: exercise

    expect(rendered).to have_css(".not-started")
  end
end
