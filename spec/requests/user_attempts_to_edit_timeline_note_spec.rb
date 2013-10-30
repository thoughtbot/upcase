require 'spec_helper'

feature 'User attempts to edit a timeline note' do
  context 'that was added by them' do
    scenario 'and the note is updated successfully when the note is valid' do
      user = create(:user)
      note = NoteOnPage.create_with_defaults_for(user)
      visit timeline_path(as: user)

      note.update_body 'My updated note'

      expect(note).to be_displayed_on_page
      expect(page).to have_success_message
    end

    scenario 'and a message is displayed on the edit page when the note is invalid' do
      user = create(:user)
      note = NoteOnPage.create_with_defaults_for(user)
      visit timeline_path(as: user)

      note.update_body ''

      expect(page).to have_error_message
    end
  end

  context 'that was added by someone else' do
    scenario 'and they cannot edit the note' do
      user = create(:user, :with_mentor)
      note = NoteOnPage.create_note_written_by_someone_other_than(user)

      visit timeline_path(as: user)

      expect(note).to be_displayed_on_page
      expect(note).not_to have_edit_link
    end
  end

  private

  def have_success_message
    have_content I18n.t('notes.flashes.success')
  end

  def have_error_message
    have_content I18n.t('notes.flashes.error')
  end
end
