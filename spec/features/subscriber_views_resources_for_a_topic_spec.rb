require "rails_helper"

feature "subscriber views resources for a topic" do
  scenario "sees exercises, workshops, videos, and products" do
    topic = create(:topic, dashboard: true)
    workshop = create(:workshop)
    exercise = create(:exercise)
    video = create(:video, :published)
    book = create(:book)
    screencast = create(:screencast)

    [workshop, exercise, video, book, screencast].each do |resource|
      resource.classifications.create!(topic: topic)
    end

    sign_in_as_user_with_subscription

    expect(page).to have_css(".topic .card", count: 4)

    click_on "View All"

    expect(page).to have_content(workshop.name)
    expect(page).to have_content(exercise.title)
    expect(page).to have_content(video.title)
    expect(page).to have_css("a[title='#{book.name}']")
    expect(page).to have_content(screencast.name)
  end
end
