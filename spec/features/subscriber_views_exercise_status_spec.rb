require "rails_helper"

feature "Subscriber sees the current status of an exercise" do
  scenario "subscriber has not started exercise" do
    topic = create(:topic, dashboard: true)
    exercise = create(:exercise, :public)
    exercise.classifications.create!(topic: topic)

    sign_in
    visit explore_path

    expect(page).to have_exercise_title "Exercise"
  end

  scenario "subscriber has started exercise" do
    topic = create(:topic, dashboard: true)
    exercise = create(:exercise, :public)
    user = create(:user, :with_subscription)
    exercise.classifications.create!(topic: topic)
    exercise.statuses.create!(user: user)

    sign_in_as user
    visit explore_path

    expect(page).to have_exercise_title "In Progress"
    expect(page).not_to have_exercise_title "Exercise"
  end

  def have_exercise_title(title)
    have_selector(".exercise h5:contains('#{title}')")
  end
end
