require "rails_helper"

feature "Subscriber sees the current status of an exercise" do
  scenario "subscriber has not started exercise" do
    topic = create(:topic, dashboard: true)
    exercise = create(:exercise)
    exercise.classifications.create!(topic: topic)

    sign_in
    visit dashboard_path

    within ".card.exercise" do
      expect(page).to have_content "Not Started"
    end
  end

  scenario "subscriber has started exercise" do
    topic = create(:topic, dashboard: true)
    exercise = create(:exercise)
    user = create(:user, :with_subscription)
    exercise.classifications.create!(topic: topic)
    exercise.statuses.create!(user: user)

    sign_in_as user
    visit dashboard_path

    within ".card.exercise" do
      expect(page).to have_content "Started"
      expect(page).not_to have_content "Not Started"
    end
  end
end
