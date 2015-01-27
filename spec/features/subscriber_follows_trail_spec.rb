require "rails_helper"

feature "subscriber follows trail" do
  scenario "clicks into exercise" do
    exercises = [
      create(:exercise, name: "First Exercise"),
      create(:exercise, name: "Second Exercise")
    ]
    create(:trail, :published, name: "Baby Exercises", exercises: exercises)

    sign_in_as_user_with_subscription
    click_on "First Exercise"

    expect(page).to have_content("Exercise: First Exercise")
  end

  scenario "sees status based on completed exercises" do
    exercises = [
      create(:exercise, name: "First Exercise"),
      create(:exercise, name: "Second Exercise")
    ]
    create(:trail, :published, name: "Baby Exercises", exercises: exercises)
    user = create(:subscriber)
    exercises.first.statuses.create!(user: user, state: Status::COMPLETE)

    visit practice_path(as: user)

    expect(page).to have_content("1 step remaining")
  end
end
