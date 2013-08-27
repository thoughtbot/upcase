require 'spec_helper'

describe 'In-person Workshop' do
  it 'is sold out when full' do
    workshop = create(:workshop, maximum_students: 1)
    section = create(
      :section,
      workshop: workshop,
      starts_on: 1.week.from_now,
      ends_on: 2.weeks.from_now
    )
    create_subscriber_purchase_from_purchaseable(section)

    visit workshop_path(workshop)

    expect_to_see_follow_up_link
    page.should have_content 'Sold Out'
    page.should have_content 'Want to be notified the next time'
  end
end

describe 'Online Workshop' do
  it 'is sold out when full' do
    workshop = create(:online_workshop, maximum_students: 1)
    section = create(
      :section,
      workshop: workshop,
      starts_on: 1.week.from_now,
      ends_on: 2.weeks.from_now
    )
    create_subscriber_purchase_from_purchaseable(section)

    visit workshop_path(workshop)

    expect_to_see_follow_up_link
    page.should have_content 'Sold Out'
    page.should have_content 'Want to be notified the next time'
  end
end

def expect_to_see_follow_up_link
  expect(page).to have_css("a.button[href='#new_follow_up']", text: "Get notified")
end
