require "rails_helper"

feature "User without a subscription views sample video" do
  scenario "successfully" do
    user = create(:user)
    trail = create(:trail, :video)
    video = trail.first_completeable
    video.update accessible_without_subscription: true

    visit trail_path(trail)
    click_on "Start Course For Free"

    expect(user.has_active_subscription?).to eq(false)
    expect(current_path).to eq(video_path(video))
    expect(page).to have_css("h1", text: video.name)
    expect(page).not_to have_css(".locked-message")
  end
end
