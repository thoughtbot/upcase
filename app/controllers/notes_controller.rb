class NotesController < ApplicationController
  before_action :authorize
  before_action :redirect_unless_user_is_allowed_to_post

  def create
    if note_body_is_present?
      create_note_and_reload_timeline
    else
      redirect_to_users_timeline_with_flash_error
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(note_params)
      redirect_to correct_timeline_path, notice: t('notes.flashes.success')
    else
      render_edit_form_with_flash_error
    end
  end

  private

  def redirect_unless_user_is_allowed_to_post
    unless current_user_allowed_to_post?
      flash[:error] = 'You do not have permission to post to that timeline.'
      redirect_to correct_timeline_path
    end
  end

  def redirect_to_users_timeline_with_flash_error
    flash[:error] = t('notes.flashes.error')
    redirect_to correct_timeline_path
  end

  def correct_timeline_path
    if current_user.admin?
      user_timeline_path(@note.user)
    else
      timeline_path
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

  def create_note_and_reload_timeline
    timeline_user.notes.create!(note_params)
    redirect_to :back
  end

  def render_edit_form_with_flash_error
    flash[:error] = t('notes.flashes.error')
    render :edit
  end

  def timeline_user
    User.find(params[:user_id])
  end

  def note_params
    params.
      require(:note).
      permit(
        :body
      ).
      merge(contributor_id: current_user.id)
  end
end
