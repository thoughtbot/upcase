require "rails_helper"

RSpec.feature "user views trail details" do
  scenario "sees progress" do
    exercises = [
      create(:exercise, name: "First Exercise"),
      create(:exercise, name: "Second Exercise")
    ]
    video = create(:video, name: "First Video")
    create(
      :trail,
      :published,
      :with_topic,
      name: "Baby Exercises",
      exercises: exercises,
      videos: [video]
    )
    teacher = create(:user, bio: generate(:bio))
    create(:teacher, user: teacher, video: video)
    user = create(:user)
    exercises.first.statuses.create!(user: user, state: Status::COMPLETE)

    visit practice_path(as: user)
    click_link "Baby Exercises"

    expect(page).to have_content("Baby Exercises")
    expect(page).to have_content("First Exercise")
    expect(page).to have_content("Second Exercise")
    expect(page).to have_content("First Video")
    expect(page).to have_content("2 steps remaining")
    expect(page).to have_content(teacher.bio)
  end
end
