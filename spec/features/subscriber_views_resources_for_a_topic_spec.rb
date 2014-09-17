require "rails_helper"

feature "subscriber views resources for a topic" do
  scenario "sees exercises, video_tutorials, videos, and products" do
    topic = create(:topic, dashboard: true)
    video_tutorial = create(:video_tutorial)
    exercise = create(:exercise)
    video = create(:video, :published)

    [video_tutorial, exercise, video].each do |resource|
      resource.classifications.create!(topic: topic)
    end

    sign_in_as_user_with_subscription

    expect(page).to have_css(".topic .card", count: 4)

    click_on "View All"

    expect(page).to have_content(video_tutorial.name)
    expect(page).to have_content(exercise.title)
    expect(page).to have_content(video.title)
  end
end
