class NoteOnPage
  include Capybara::DSL

  def initialize(body)
    @body = body
  end

  def self.create_with_defaults_for(user)
    note = FactoryGirl.create :note, user: user
    new(note.body)
  end

  def self.create_note_written_by_someone_other_than(user)
    note = FactoryGirl.create(:note, user: user, contributor_id: user.mentor.id)
    new(note.body)
  end

  def create
    within '.timeline-notes' do
      fill_in 'note_body', with: body
      click_on 'save this note'
    end
  end

  def update_body(body)
    @body = body
    note.click_on 'edit'
    fill_in 'note_body', with: body
    click_on 'Save changes'
  end

  def displayed_on_page?
    has_content? body
  end

  def has_content?(content)
    note.has_content?(content)
  end

  def has_edit_link?
    note.has_link? 'edit'
  end

  def has_success_flash_message?
    flash.has_content? I18n.t('notes.flashes.success')
  end

  def has_error_flash_message?
    flash.has_content? I18n.t('notes.flashes.error')
  end

  private
  attr_accessor :body

  def note
    find('[data-role="note"]')
  end

  def flash
    find('.flash')
  end
end
