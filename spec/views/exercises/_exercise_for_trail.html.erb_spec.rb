require "rails_helper"

describe "exercises/_exercise_for_trail.html" do
  it "renders a class based on the exercise state" do
    stub_user
    exercise = stub_exercise(state: "Two Words")

    render "exercises/exercise_for_trail", exercise: exercise

    expect(rendered).to have_css(".two-words-exercise")
  end

  def stub_user
    view_stubs(:current_user_has_access_to?).and_return(true)
    build_stubbed(:user).tap do |user|
      view_stubs(:current_user).and_return(user)
    end
  end

  def stub_exercise(state: "Imaginary")
    exercise = double("Exercise")
    allow(exercise).to receive(:state).and_return(state)
    allow(exercise).to receive(:can_be_accessed?).and_return(true)
    allow(exercise).to receive(:url).and_return("http://example.com")
    allow(exercise).to receive(:name).and_return("Name")
    allow(exercise).to receive(:summary).and_return("Summary")
    exercise
  end
end
