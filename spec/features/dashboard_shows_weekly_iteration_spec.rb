require "rails_helper"

feature "User without a subscription" do
  scenario "Sees The Weekly Iteration section in Explore" do
    show = create(:show, name: Show::THE_WEEKLY_ITERATION)

    visit explore_path(as: create(:user))

    expect(page).to have_content(show.name)
    expect(page).to have_content("more episodes")
  end
end
