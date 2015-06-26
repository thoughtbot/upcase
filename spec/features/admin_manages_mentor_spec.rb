require "rails_helper"

feature 'Admin manages mentors' do
  scenario 'creating a new mentor' do
    user = create(:admin)

    visit admin_root_path(as: user)
    click_link 'Mentors'
    click_link 'New mentor'
    select(user.name, from: 'User')
    click_button 'Create Mentor'

    expect(page).to have_content('Mentor was successfully created')
  end
end
