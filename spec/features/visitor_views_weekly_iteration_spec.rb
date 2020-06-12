require "rails_helper"

feature "Visitor" do
  scenario "views Weekly Iteration preview page" do
    show = create(:the_weekly_iteration)
    create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show.name)
  end

  scenario "clicks through to an episode" do
    show = create(:the_weekly_iteration)
    video = create_video(show)

    visit show_url(show)
    click_link video.name

    expect(page).to have_content(video.notes)
    expect(page).to have_auth_cta(video)
  end

  scenario "navigates directly to a video and signs in" do
    show = create(:the_weekly_iteration)
    video = create_video(show)
    desired_video_path = video_path(video)

    visit desired_video_path
    click_link "Sign In"
    click_link "Sign in with GitHub"

    expect(current_path).to eq(desired_video_path)
  end

  def create_video(show)
    name_with_unsafe_character = "Unfriendly Nil's Unfriendly"
    create(
      :video,
      :published,
      :with_preview,
      name: name_with_unsafe_character,
      notes: 'Notes',
      watchable: show,
    )
  end

  def have_auth_cta(video)
    have_link(
      I18n.t("videos.show.auth_to_access_button_text"),
      href: video_auth_to_access_path(video),
    )
  end
end
