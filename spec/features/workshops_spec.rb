require 'spec_helper'

describe 'Workshops' do
  include PurchasesHelper

  it 'displays their formatted resources' do
    workshop = create(:workshop, resources: "* Item 1\n*Item 2")
    video = create(:video, watchable: workshop)
    purchase = create_subscriber_purchase_from_purchaseable(workshop)

    visit purchase_path(purchase)

    expect(page).to have_css('.resources li', text: 'Item 1')
    visit purchase_video_path(purchase, video)
    expect(page).to have_css('.resources li', text: 'Item 1')
  end

  it 'lists office hours' do
    workshop = create(:workshop)
    create(:video, watchable: workshop)
    purchase = create_subscriber_purchase_from_purchaseable(workshop)

    visit purchase_path(purchase)

    expect(page).to have_css('.office-hours', text: OfficeHours.time)
  end
end
