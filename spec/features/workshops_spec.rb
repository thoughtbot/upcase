require 'rails_helper'

describe 'Workshops', :type => :feature do
  it 'displays their formatted resources' do
    user = create(:user)
    workshop = create(:workshop, resources: "* Item 1\n*Item 2")
    create(:video, watchable: workshop)
    license = create_license_from_licenseable(workshop, user)

    visit workshop_path(workshop, as: user)

    expect(page).to have_css('.resources li', text: 'Item 1')
  end

  it 'lists office hours' do
    user = create(:user)
    workshop = create(:workshop)
    create(:video, watchable: workshop)
    license = create_license_from_licenseable(workshop, user)

    visit workshop_path(workshop, as: user)

    expect(page).to have_css('.office-hours', text: OfficeHours.time)
  end
end
