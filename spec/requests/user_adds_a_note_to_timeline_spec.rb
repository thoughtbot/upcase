require 'spec_helper'

feature 'User adds a note to timeline', :js do
  scenario 'they see the note form hidden until they click "Add a note"' do
    user = create(:user)
    visit timeline_path(as: user)

    expect(page).to have_css '.add-note-form', visible: false
    click_on 'Add a note'

    expect(page).to have_css '.add-note-form', visible: true
  end

  scenario 'they see only one add note form when there are multiple weeks' do
    user = create(:user)
    trail = create(:trail, trail_map: FakeTrailMap.new.trail)
    create(:completion, :previous_week, user: user, trail_object_id: FakeTrailMap.new.resource_id)
    create(:note, :current_week, user: user)

    visit timeline_path(as: user)

    expect(week_sections.count).to eq 2
    expect(page.all('.add-note-form').count).to eq 1
  end

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

    expect(page).to have_css '[data-role="note"] h1', text: 'I love to learn'
  end

  private

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end

  def create_note(body)
    within '.notes' do
      click_on 'Add a note'
      fill_in 'note_body', with: body
      click_on 'Save'
    end
  end

  def week_sections
    page.all('.week')
  end
end
