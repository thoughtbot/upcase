class NotesController < ApplicationController
  before_filter :authorize

  def create
    current_user.notes.create!(note_params)
    redirect_to :back
  end

  private

  def note_params
    params.require(:note).permit(:body)
  end
end
