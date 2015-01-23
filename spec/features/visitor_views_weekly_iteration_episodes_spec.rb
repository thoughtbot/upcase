require "rails_helper"

feature "Visitor" do
  scenario "views Weekly Iteration episodes" do
    show_name = Show::THE_WEEKLY_ITERATION
    show = create(:show, name: show_name)
    create(:basic_plan)
    video_name_with_unsafe_character = "Unfriendly Nil's Unfriendly"
    video_notes = "Nil is contagious."
    create(
      :video,
      :published,
      :with_preview,
      name: video_name_with_unsafe_character,
      notes: video_notes,
      watchable: show
    )
    video = create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show_name)
    expect_page_to_have_title("#{show.title} | Upcase")
    expect(page).not_to have_content(video.name)
    expect_page_to_have_preview_cta

    click_link video_name_with_unsafe_character

    expect(page).to have_content(video_notes)
    expect_page_to_have_preview_cta
    expect(page).to have_content(
      "Subscribe to #{I18n.t('shared.subscription.name')}"
    )
    expect_page_to_have_title("#{video_name_with_unsafe_character} | Upcase")
  end

  def expect_page_to_have_preview_cta
    expect(page.body).to include(
      I18n.t("watchables.preview.cta", subscribe_url: subscribe_path).html_safe
    )
  end
end
