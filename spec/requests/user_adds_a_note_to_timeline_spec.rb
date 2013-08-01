require 'spec_helper'

feature 'User adds a note to timeline' do
  scenario 'they see the note on the timeline page' do
    user = create(:user)
    visit timeline_path(as: user)

    fill_in 'note_body', with: 'I love to learn'
    click_on 'Save'

    expect(page).to have_role 'note', text: 'I love to learn'
  end
end
