require 'spec_helper'

feature 'User adds a note to timeline' do
  scenario 'they see only one add note form when there are multiple weeks' do
    user = create(:user)
    trail = create(:trail, trail_map: FakeTrailMap.new.trail)
    create(:completion, :previous_week, user: user, trail_object_id: FakeTrailMap.new.resource_id)
    create(:note, :current_week, user: user)

    visit timeline_path(as: user)

    expect(week_sections.count).to eq 2
    expect(page.all('.note-form').count).to eq 1
  end

  context 'with note body filled in' do
    scenario 'they see the note on the timeline page' do
      user = create(:user)
      visit timeline_path(as: user)
      note = NoteOnPage.new('I love learn')

      note.create

      expect(note).to be_displayed_on_page
    end

    scenario 'they see the note rendered as markdown' do
      user = create(:user)
      visit timeline_path(as: user)
      note = NoteOnPage.new('# I love learn')

      note.create

      expect(note).to have_content 'I love learn'
    end
  end

  context 'with a blank note body' do
    scenario 'they are redirected back to the user timeline' do
      user = create(:user)
      visit timeline_path(as: user)
      note = NoteOnPage.new('')

      note.create

      expect(current_path).to eq timeline_path
    end
  end

  scenario 'a mentor can add a note to the timeline' do
    mentor = create(:mentor)
    mentee = create(:user, mentor: mentor)
    note = NoteOnPage.new('This is a note from your mentor!')

    visit user_timeline_path(mentee, as: mentor.user)
    note.create

    expect(note).to be_displayed_on_page
  end

  private

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end

  def week_sections
    page.all('.week')
  end
end
