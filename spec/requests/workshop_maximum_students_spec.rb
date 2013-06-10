require 'spec_helper'

describe 'In-person Workshop' do
  it 'is sold out when full' do
    workshop = create(:workshop, maximum_students: 5)
    section = create(
      :section,
      workshop: workshop,
      starts_on: 1.week.from_now,
      ends_on: 2.weeks.from_now
    )
    create_list(:free_purchase, 5, purchaseable: section)

    visit workshop_path(workshop)

    page.should have_css(".button[href='#new_follow_up']", text: "Get notified")
    page.should have_content 'Sold Out'
    page.should have_content 'Want to be notified the next time'
  end
end

describe 'Online Workshop' do
  it 'is sold out when full' do
    workshop = create(:online_workshop, maximum_students: 5)
    section = create(
      :section,
      workshop: workshop,
      starts_on: 1.week.from_now,
      ends_on: 2.weeks.from_now
    )
    create_list(:free_purchase, 5, purchaseable: section)

    visit workshop_path(workshop)

    page.should have_css(".button[href='#new_follow_up']", text: "Get notified")
    page.should have_content 'Sold Out'
    page.should have_content 'Want to be notified the next time'
  end
end
