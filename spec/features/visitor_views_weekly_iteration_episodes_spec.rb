require "rails_helper"

feature 'Visitor' do
  scenario 'views Weekly Iteration episodes' do
    show_name = Show::THE_WEEKLY_ITERATION
    show = create(:show, name: show_name)
    create(:basic_plan)
    published_video_title = 'Unfriendly Nil'
    published_video_notes = 'Nil is contagious.'
    create(
      :video,
      :published,
      :with_preview,
      title: published_video_title,
      notes: published_video_notes,
      watchable: show
    )
    video = create(:video, watchable: show)

    visit show_url(show)

    expect(page).to have_content(show_name)
    expect_page_to_have_title("#{show.title} | Upcase")
    expect(page).not_to have_content(video.title)

    click_link published_video_title

    expect(page).to have_content(published_video_notes)
    expect(page).to have_content(
      "Subscribe to #{I18n.t('shared.subscription.name')}"
    )
    expect_page_to_have_title("#{published_video_title} | Upcase")
  end
end
