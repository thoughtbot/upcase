require "rails_helper"

feature "subscriber follows trail" do
  scenario "clicks into exercise" do
    trail = create(:trail, name: "Baby Exercises")
    trail.add_exercise create(:exercise, title: "First Exercise")
    trail.add_exercise create(:exercise, title: "Second Exercise")

    sign_in_as_user_with_subscription
    click_on "First Exercise"

    expect(page).to have_content("Exercise: First Exercise")
  end

  scenario "sees status based on completed exercises" do
    trail = create(:trail, name: "Baby Exercises")
    first_exercise = create(:exercise, title: "First Exercise")
    trail.add_exercise first_exercise
    trail.add_exercise create(:exercise, title: "Second Exercise")
    user = create(:subscriber)
    first_exercise.statuses.create!(user: user, state: Status::REVIEWED)

    visit dashboard_path(as: user)

    expect(page).to have_content("1 step remaining")
  end
end
