require 'spec_helper'

feature 'User adds a note to timeline' do
  scenario 'they see the note on the timeline page' do
    user = create(:user)
    visit timeline_path(as: user)

    create_note('I love to learn')

    expect(page).to have_role 'note', text: 'I love to learn'
  end

  scenario 'they see the note rendered as markdown' do
    user = create(:user)
    visit timeline_path(as: user)

    create_note('# I love to learn')

    expect(page).to have_css '[data-role="note"] span h1', text: 'I love to learn'
  end

  private

  def create_note(body)
    fill_in 'note_body', with: body
    click_on 'Save'
  end
end
