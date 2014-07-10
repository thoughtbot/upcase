require 'spec_helper'

feature 'Visitor' do
  scenario 'views Weekly Iteration episodes' do
    show_name = Show::THE_WEEKLY_ITERATION
    show = create(:show, name: show_name)
    plan = create(:individual_plan, sku: IndividualPlan::PRIME_29_SKU)
    published_video_title = 'Unfriendly Nil'
    published_video_notes = 'Nil is contagious.'
    create(
      :video,
      :published,
      title: published_video_title,
      notes: published_video_notes,
      watchable: show
    )
    video = create(:video, watchable: show)

    visit '/the-weekly-iteration'

    expect(page).to have_content(show_name)

    expect(page).not_to have_content(video.title)

    click_link published_video_title

    expect(page).to have_content(published_video_notes)
    expect(page).to have_content(I18n.t('weekly_iteration_subscribe_cta'))
    expect(page).to have_content(plan.individual_price)
  end
end
