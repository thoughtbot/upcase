require "rails_helper"

feature "Visitor" do
  scenario "views Weekly Iteration preview page" do
    show = create(:the_weekly_iteration)
    create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show.name)
    expect(page).to have_show_preview_cta
  end

  scenario "clicks through to an episode" do
    show = create(:the_weekly_iteration)
    video = create_video(show)

    visit show_url(show)
    click_link video.name

    expect(page).to have_content(video.notes)
    expect(page).to have_video_preview_callout
    expect(page).to have_subscribe_cta
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
      name: name_with_unsafe_character,
      watchable: show,
    )
  end

  def have_show_preview_cta
    have_content(I18n.t("watchables.preview.subscribe_cta"))
  end

  def have_video_preview_callout
    have_content I18n.t("videos.show.access_callout_for_preview_text")
  end

  def have_subscribe_cta
    have_link(
      I18n.t("videos.show.access_callout_for_preview_button"),
      href: professional_checkout_path,
    )
  end

  def professional_checkout_path
    new_checkout_path(plan: Plan::PROFESSIONAL_SKU)
  end
end
