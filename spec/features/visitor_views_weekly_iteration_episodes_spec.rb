require 'spec_helper'

feature 'Visitor' do
  scenario 'views Weekly Iteration episodes' do
    show_name = Show::THE_WEEKLY_ITERATION
    show = create(:show, name: show_name)
    create(:individual_plan, sku: IndividualPlan::PRIME_BASIC_SKU)
    video_title = 'Unfriendly Nil'
    video_notes = 'Nil is contagious.'
    create(:video, title: video_title, notes: video_notes, watchable: show)

    visit '/the-weekly-iteration'

    expect(page).to have_content(show_name)

    click_link video_title

    expect(page).to have_content(video_notes)
    expect(page).to have_content(I18n.t('weekly_iteration_subscribe_cta'))
  end
end
