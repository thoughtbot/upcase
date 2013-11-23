require 'spec_helper'

describe 'Workshops' do
  include PurchasesHelper

  it 'displays their formatted resources' do
    workshop = create(:workshop, resources: "* Item 1\n*Item 2")
    section = create(:section, starts_on: Time.zone.today, ends_on: 1.month.from_now, workshop: workshop)
    video = create(:video, watchable: workshop)
    purchase = create_subscriber_purchase_from_purchaseable(section)

    visit purchase_path(purchase)

    expect(page).to have_css('.resources li', text: 'Item 1')
    visit purchase_video_path(purchase, video)
    expect(page).to have_css('.resources li', text: 'Item 1')
  end

  it 'lists office hours' do
    workshop = create(:workshop)
    section = create(:section, starts_on: 7.days.from_now, ends_on: 1.month.from_now, workshop: workshop)
    create(:video, watchable: workshop)
    purchase = create_subscriber_purchase_from_purchaseable(section)

    visit purchase_path(purchase)

    expect(page).to have_css('.office-hours', text: OfficeHours.time)
  end

  it 'that are online include the date range' do
    purchase = create_subscriber_purchase(:online_section)

    visit purchase_path(purchase)

    expect(page).to have_content(purchase_date_range(purchase))
  end

  it 'that are in person include the date range and time' do
    purchase = create_subscriber_purchase(:in_person_section)

    visit purchase_path(purchase)

    expect(page).to have_content(purchase_date_range(purchase))
    expect(page).to have_content(purchase.purchaseable.time_range)
  end
end
