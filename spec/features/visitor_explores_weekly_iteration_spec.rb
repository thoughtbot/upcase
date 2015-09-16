require "rails_helper"

feature "User without a subscription" do
  scenario "Sees latest TWI and Video Tutorial in Explore" do
    show = create(:show, name: Show::THE_WEEKLY_ITERATION)
    twi_video = create(:video, :published, watchable: show)
    trail = create(:trail, :published, :video)

    visit explore_path(as: create(:user))

    expect(page).to have_content(show.name)
    expect(page).to have_content(show.tagline)
    expect(page).to have_content(twi_video.name)
    expect(page).to have_content("View All Episodes")

    expect(page).to have_content(trail.name)
    expect(page).to have_content(trail.description)
    expect(page).to have_content("View All Trails")
  end
end
