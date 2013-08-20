class NotesController < ApplicationController
  before_filter :authorize

  def create
    if current_user_allowed_to_post? && note_body_is_present?
      create_note_and_reload_timeline
    else
      redirect_to_current_user_timeline
    end
  end

  private

  def current_user_allowed_to_post?
    current_user_is_timeline_user? || current_user_is_admin?
  end

  def note_body_is_present?
    params[:note][:body].present?
  end

  def current_user_is_timeline_user?
    current_user == timeline_user
  end

  def redirect_to_current_user_timeline
    flash[:error] = 'You do not have permission to post to that timeline.'
    redirect_to timeline_path
  end

  def create_note_and_reload_timeline
    timeline_user.notes.create!(note_params)
    redirect_to :back
  end

  def timeline_user
    User.find(note_params[:timeline_user_id])
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
