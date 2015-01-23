require "rails_helper"

feature "User without a subscription" do
  scenario "Sees latest TWI and Video Tutorial in Explore" do
    show = create(:show, name: Show::THE_WEEKLY_ITERATION)
    twi_video = create(:video, :published, watchable: show)
    video_tutorial = create(:video_tutorial)

    visit explore_path(as: create(:user))

    expect(page).to have_content(show.name)
    expect(page).to have_content(show.tagline)
    expect(page).to have_content(twi_video.name)
    expect(page).to have_content("View All Episodes")

    expect(page).to have_content(video_tutorial.name)
    expect(page).to have_content(video_tutorial.tagline)
    expect(page).to have_content("View All Videos")
  end
end
