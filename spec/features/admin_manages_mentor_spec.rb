require "rails_helper"

feature 'Admin manages mentors' do
  scenario 'creating a new mentor' do
    user = create(:admin)

    visit admin_path(as: user)
    click_link 'Mentors'
    click_link 'Add new'
    select(user.name, from: 'User')
    click_button 'Save'

    expect(page).to have_content('Mentor successfully created')
  end
end
