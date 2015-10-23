require "rails_helper"

feature "Visitor" do
  scenario "views Weekly Iteration preview page" do
    show = create(:the_weekly_iteration)
    create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show.name)
    expect_page_to_have_preview_cta
    expect_to_see_call_to_subscribe_to_upcase
  end

  scenario "clicks through to an episode" do
    show = create(:the_weekly_iteration)
    video = create_video(show)

    visit show_url(show)
    click_link video.name

    expect(page).to have_content(video.notes)
    expect_page_to_have_preview_cta
    expect_to_see_call_to_subscribe_to_upcase
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

  def expect_page_to_have_preview_cta
    expect(page.body).to include(
      I18n.t("watchables.preview.cta", subscribe_url: join_path).html_safe,
    )
  end

  def expect_to_see_call_to_subscribe_to_upcase
    expect(page).to have_content(
      "Subscribe to #{I18n.t('shared.subscription.name')}",
    )
  end
end
