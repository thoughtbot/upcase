require "rails_helper"

describe "products/exercises/_exercise.html" do
  it "renders links to exercises for users with access" do
    view_stubs(:current_user)
    view_stubs(:current_user_has_access_to?).with(:exercises).returns(true)
    exercise = build_stubbed(:exercise, url: "http://example.com/exercise")

    render "products/exercises/exercise", exercise: exercise

    expect(rendered).to have_css("a[href='http://example.com/exercise']")
  end

  it "does not render links to exercises for users without access" do
    view_stubs(:current_user)
    view_stubs(:current_user_has_access_to?).with(:exercises).returns(false)

    render "products/exercises/exercise", exercise: build_stubbed(:exercise)

    expect(rendered).not_to have_css("a[href]")
  end
end
