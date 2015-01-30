require "rails_helper"

describe "Trail list" do
  scenario "user views all published trails" do
    exercise = create(:exercise, name: "This is an exercise")
    video = create(:video, name: "This is a video")
    published_trail = create(
      :trail,
      :published,
      name: "This is a published trail",
      videos: [video],
      exercises: [exercise],
    )
    unpublished_trail = create(
      :trail,
      name: "This is an unpublished trail",
      videos: [video],
      exercises: [exercise],
      published: false
    )
    create(:topic, featured: true, trails: [published_trail, unpublished_trail])

    visit trails_path

    expect(page).to have_content("This is a published trail")
    expect(page).to have_content("This is an exercise")
    expect(page).to have_content("This is a video")
    expect(page).not_to have_content("This is an unpublished trail")
  end
end
