require "rails_helper"

feature 'Visitor' do
  scenario 'views Weekly Iteration episodes' do
    show_name = Show::THE_WEEKLY_ITERATION
    show = create(:show, name: show_name)
    create(:basic_plan)
    video_title_with_unsafe_character = "Unfriendly Nil's Unfriendly"
    video_notes = 'Nil is contagious.'
    create(
      :video,
      :published,
      :with_preview,
      title: video_title_with_unsafe_character,
      notes: video_notes,
      watchable: show
    )
    video = create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show_name)
    expect_page_to_have_title("#{show.title} | Upcase")
    expect(page).not_to have_content(video.title)

    click_link video_title_with_unsafe_character

    expect(page).to have_content(video_notes)
    expect(page).to have_content(
      "Subscribe to #{I18n.t('shared.subscription.name')}"
    )
    expect_page_to_have_title("#{video_title_with_unsafe_character} | Upcase")
  end
end
