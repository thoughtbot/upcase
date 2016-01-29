require "rails_helper"

feature "Visitor" do
  scenario "views Weekly Iteration preview page" do
    show = create(:the_weekly_iteration)
    create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show.name)
    expect_page_to_have_show_preview_cta
    expect_to_see_call_to_subscribe_to_upcase
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

  def create_video(show)
    name_with_unsafe_character = "Unfriendly Nil's Unfriendly"
    create(
      :video,
      :published,
      name: name_with_unsafe_character,
      watchable: show,
    )
  end

  def expect_page_to_have_show_preview_cta
    expect(page.body).to include(
      I18n.t("watchables.preview.cta", subscribe_url: join_path).html_safe,
    )
  end

  def expect_to_see_call_to_subscribe_to_upcase
    expect(page).to have_content(
      "Subscribe to #{I18n.t('shared.subscription.name')}",
    )
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
