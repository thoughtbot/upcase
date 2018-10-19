require "rails_helper"

feature "user starts a trail" do
  scenario "clicks into exercise" do
    exercises = [
      create(:exercise, name: "First Exercise"),
      create(:exercise, name: "Second Exercise")
    ]
    create(:trail, :published, name: "Baby Exercises", exercises: exercises)

    sign_in
    click_on I18n.t("pages.landing.hero_call_to_action")
    click_on "Start trail"

    expect(page).to have_content("Exercise: First Exercise")
  end

  scenario "sees status based on completed exercises" do
    exercises = [
      create(:exercise, name: "First Exercise"),
      create(:exercise, name: "Second Exercise")
    ]
    create(:trail, :published, name: "Baby Exercises", exercises: exercises)
    user = create(:user)
    exercises.first.statuses.create!(user: user, state: Status::COMPLETE)

    visit practice_path(as: user)

    expect(page).to have_content("1 step remaining")
  end
end
