require 'spec_helper'

describe 'Workshops' do
  it 'displays their formatted resources' do
    workshop = create(:workshop, resources: "* Item 1\n*Item 2")
    section = create(:section, starts_on: Date.today, ends_on: 1.month.from_now, workshop: workshop)
    video = create(:video, watchable: workshop, active_on_day: 0, title: 'Video One')
    purchase = create(:paid_purchase, purchaseable: section)

    visit purchase_path(purchase)

    expect(page).to have_css('.resources li', text: 'Item 1')
    visit purchase_video_path(purchase, video)
    expect(page).to have_css('.resources li', text: 'Item 1')
  end

  it 'links to the video chat url and lists office hours' do
    workshop = create(:workshop, video_chat_url: 'http://example.com', office_hours: '1pm EST')
    section = create(:section, starts_on: 7.days.from_now, ends_on: 1.month.from_now, workshop: workshop)
    video = create(:video, watchable: workshop, active_on_day: 0, title: 'Video One')
    purchase = create(:paid_purchase, purchaseable: section)

    visit purchase_path(purchase)

    expect(page).to have_css('.video-chat a.button[href="http://example.com"]')
    expect(page).to have_css('.video-chat', text: '1pm EST')
    visit purchase_video_path(purchase, video)
    expect(page).to have_css('.video-chat a.button[href="http://example.com"]')
  end

  it 'includes support' do
    section = create(:section)
    purchase = create(:paid_purchase, purchaseable: section)

    visit purchase_path(purchase)

    expect(page).to have_content('includes support')
  end
end
