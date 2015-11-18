require "rails_helper"

feature "User without a subscription views sample video" do
  scenario "successfully" do
    user = create(:user)
    trail = create(:trail, :video)
    video = trail.first_completeable
    video.update accessible_without_subscription: true

    visit trail_path(trail)
    click_on I18n.t("trails.start_for_free")

    expect(user.has_active_subscription?).to eq(false)
    expect(current_path).to eq(video_path(video))
    expect(page).to have_free_access_flash_message
    expect(page).to have_css("h1", text: video.name)
    expect(page).not_to have_css(".locked-message")
    expect_authed_to_access_event_fired_for(video)
  end

  def have_free_access_flash_message
    have_content I18n.t("authenticating.auth_to_access_success")
  end

  def expect_authed_to_access_event_fired_for(video)
    expect(analytics).to have_tracked("Authed to Access").with_properties(
      video_name: video.name,
      watchable_name: video.watchable_name,
    )
  end
end
