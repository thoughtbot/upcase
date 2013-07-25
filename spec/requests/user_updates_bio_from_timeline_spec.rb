require 'spec_helper'

feature 'User updates bio from timeline' do
  scenario 'they see the newly updated bio' do
    user = create(:user)
    visit timeline_path(as: user)

    click_on 'edit bio'
    fill_in 'About You', with: 'All about me'
    click_on 'Update account'

    expect(page).to have_field 'About You', text: 'All about me'
  end
end
