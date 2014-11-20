require "rails_helper"

feature "subscriber views trail details" do
  scenario "sees progress" do
    exercises = [
      create(:exercise, title: "First Exercise"),
      create(:exercise, title: "Second Exercise")
    ]
    create(:trail, :published, name: "Baby Exercises", exercises: exercises)
    user = create(:subscriber)
    exercises.first.statuses.create!(user: user, state: Status::COMPLETE)

    visit practice_path(as: user)
    click_link "Baby Exercises"

    expect(page).to have_content("Baby Exercises")
    expect(page).to have_content("First Exercise")
    expect(page).to have_content("Second Exercise")
    expect(page).to have_content("1 step remaining")
  end
end
