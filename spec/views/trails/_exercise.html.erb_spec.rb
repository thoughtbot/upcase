require "rails_helper"

describe "trails/_exercise.html" do
  it "renders a class based on the exercise state" do
    stub_user
    exercise = stub_exercise(state: "Two Words")

    render "trails/exercise", exercise: exercise

    expect(rendered).to have_css(".two-words")
  end

  def stub_user
    build_stubbed(:user).tap do |user|
      user.stubs(:has_access_to?).returns(true)
      view_stubs(:current_user).returns(user)
    end
  end

  def stub_exercise(state: "Imaginary")
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      build_stubbed(:exercise). tap do |exercise|
        exercise.stubs(:can_be_accessed?)
        exercise.stubs(:state).returns(state)
      end
    end
  end
end
