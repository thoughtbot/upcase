class NotesController < ApplicationController
  before_filter :authorize
  before_action :redirect_unless_user_is_allowed_to_post

  def create
    if note_body_is_present?
      create_note_and_reload_timeline
    else
      redirect_to_current_user_timeline_with_flash_error
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @note.update_attributes(note_params)
    redirect_to correct_timeline_path, notice: 'Successfully updated the note'
  end

  private

  def correct_timeline_path
    if current_user.admin?
      user_timeline_path(@note.user)
    else
      timeline_path
    end
  end

  def redirect_unless_user_is_allowed_to_post
    unless current_user_allowed_to_post?
      redirect_to_current_user_timeline_with_flash_error
    end
  end

  def current_user_allowed_to_post?
    current_user_is_timeline_user? || current_user_is_admin?
  end

  def note_body_is_present?
    params[:note][:body].present?
  end

  def current_user_is_timeline_user?
    current_user == timeline_user
  end

  def redirect_to_current_user_timeline_with_flash_error
    flash[:error] = 'You do not have permission to post to that timeline.'
    redirect_to timeline_path
  end

  def create_note_and_reload_timeline
    timeline_user.notes.create!(note_params)
    redirect_to :back
  end

  def timeline_user
    if note_already_exists?
      Note.find(params[:id]).user
    else
      User.find(note_params[:timeline_user_id])
    end
  end

  def note_already_exists?
    params[:id]
  end

  def note_params
    params.
      require(:note).
      permit(
        :body,
        :timeline_user_id,
      ).
      merge(contributor_id: current_user.id)
  end
end
