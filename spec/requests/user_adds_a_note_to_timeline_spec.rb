require 'spec_helper'

feature 'User adds a note to timeline' do
  include Gravatarify::Helper

  scenario 'they see only one add note form when there are multiple weeks' do
    user = create(:user)
    trail = create(:trail, trail_map: FakeTrailMap.new.trail)
    create(:completion, :previous_week, user: user, trail_object_id: FakeTrailMap.new.resource_id)
    create(:note, :current_week, user: user)

    visit timeline_path(as: user)

    expect(week_sections.count).to eq 2
    expect(page.all('.add-note-form').count).to eq 1
  end

  context 'with note body filled in' do
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

      expect(page).to have_role 'note', text: 'I love to learn'
    end
  end

  context 'with a blank note body' do
    scenario 'they are redirected back to the user timeline' do
      user = create(:user)
      visit timeline_path(as: user)

      create_note('')

      expect(current_path).to eq timeline_path
    end
  end

  scenario 'a mentor can add a note to the timeline' do
    mentor = create(:mentor)
    mentee = create(:user, mentor: mentor)

    visit user_timeline_path(mentee, as: mentor)
    create_note('This is a note from your mentor!')

    expect(page).to have_role 'note', text: 'This is a note from your mentor!'
  end

  private

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end

  def create_note(body)
    within '.notes' do
      fill_in 'note_body', with: body
      click_on 'save this note'
    end
  end

  def week_sections
    page.all('.week')
  end
end
